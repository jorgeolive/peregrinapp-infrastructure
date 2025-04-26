param (
    [string]$dbname = "geodata",
    [string]$username = "admin",
    [string]$container = "postgis",
    [string]$password = "admin"
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "postgis_db_${timestamp}.sql"

Write-Host "Backing up PostGIS database from container '$container' to $backupFile"

# Set PGPASSWORD environment variable for passwordless backup
$env:PGPASSWORD = $password

try {
    # Run pg_dump inside the container
    docker exec $container pg_dump -U $username $dbname > $backupFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✔ Database backup completed successfully: $backupFile"
    } else {
        Write-Host "❌ Error during backup process"
        exit 1
    }
} finally {
    # Clear the password from environment
    Remove-Item Env:\PGPASSWORD
} 