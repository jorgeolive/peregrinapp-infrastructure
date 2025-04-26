param (
    [Parameter(Mandatory=$true)]
    [string]$backupFile,
    [string]$dbname = "geodata",
    [string]$username = "admin",
    [string]$container = "postgis",
    [string]$password = "admin"
)

if (-not (Test-Path $backupFile)) {
    Write-Host "Please provide a valid backup file path."
    exit 1
}

Write-Host "Restoring PostGIS database to container '$container' from $backupFile"

# Set PGPASSWORD environment variable for passwordless operations
$env:PGPASSWORD = $password

try {
    # First, terminate existing connections and drop the database
    Write-Host "Terminating existing connections..."
    docker exec $container psql -U $username -d "postgres" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$dbname' AND pid <> pg_backend_pid();"
    
    Write-Host "Dropping and recreating database..."
    docker exec $container dropdb -U $username --if-exists $dbname
    docker exec $container createdb -U $username $dbname

    # Copy the backup file into the container
    Write-Host "Copying backup file to container..."
    $containerPath = "/tmp/$(Split-Path $backupFile -Leaf)"
    Get-Content $backupFile | docker exec -i $container sh -c "cat > $containerPath"

    # Restore the database using psql
    Write-Host "Restoring database..."
    docker exec $container psql -U $username -d $dbname -f $containerPath

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] Database restored successfully"
        # Clean up the temporary file
        docker exec $container rm $containerPath
    } else {
        Write-Host "[ERROR] Error during restore process"
        exit 1
    }
} finally {
    # Clear the password from environment
    Remove-Item Env:\PGPASSWORD
} 