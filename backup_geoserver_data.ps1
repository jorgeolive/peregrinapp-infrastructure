param (
    [string]$container = "geoserver",
    [string]$geoserver_data_dir = "/opt/geoserver_data"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "geoserver_data_${timestamp}.tar.gz"

Write-Host "Backing up GeoServer data from container '$container' to $backupFile"

try {
    # Create a tar.gz archive of the GeoServer data directory inside the container
    Write-Host "Creating backup archive inside container..."
    docker exec $container tar -czf /tmp/geoserver_backup.tar.gz -C $geoserver_data_dir .
    
    # Copy the archive from the container to host
    Write-Host "Copying backup from container to host..."
    docker cp "${container}:/tmp/geoserver_backup.tar.gz" $backupFile
    
    # Clean up temporary file in container
    docker exec $container rm /tmp/geoserver_backup.tar.gz
    
    if (Test-Path $backupFile) {
        Write-Host "✔ GeoServer data backup completed successfully: $backupFile"
    } else {
        Write-Host "❌ Error: Backup file was not created"
        exit 1
    }
} catch {
    Write-Host "❌ Error during backup process: $_"
    exit 1
} 