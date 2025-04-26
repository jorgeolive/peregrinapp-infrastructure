param (
    [Parameter(Mandatory=$true)]
    [string]$backupFile,
    [string]$container = "geoserver",
    [string]$geoserver_data_dir = "/opt/geoserver_data"
)

if (-not (Test-Path $backupFile)) {
    Write-Host "Error: Backup file not found: $backupFile"
    exit 1
}

Write-Host "Restoring GeoServer data to container '$container' from $backupFile"

try {
    # Copy the backup file to the container
    Write-Host "Copying backup file to container..."
    docker cp $backupFile "${container}:/tmp/geoserver_backup.tar.gz"

    # Clear existing data directory
    Write-Host "Clearing existing GeoServer data directory..."
    docker exec $container sh -c "rm -rf ${geoserver_data_dir}/* ${geoserver_data_dir}/.[!.]*"
    
    # Extract the backup
    Write-Host "Extracting backup archive..."
    docker exec $container tar -xzf /tmp/geoserver_backup.tar.gz -C $geoserver_data_dir

    # Clean up temporary file
    docker exec $container rm /tmp/geoserver_backup.tar.gz

    # Restart GeoServer container to apply changes
    Write-Host "Restarting GeoServer container..."
    docker restart $container

    Write-Host "[SUCCESS] GeoServer data restored successfully"
    Write-Host "GeoServer is restarting, please wait a few moments for it to be fully operational"
} catch {
    Write-Host "[ERROR] Error during restore process: $_"
    exit 1
} 