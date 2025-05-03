# build_and_run.ps1
# Script to build and run the Docker environment for PeregrinApp

Write-Host "Checking if Docker is running..." -ForegroundColor Cyan
$dockerStatus = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker is not running or not installed. Please start Docker and try again." -ForegroundColor Red
    exit 1
}

# Check if peregrinapp_backend image exists
Write-Host "Checking if peregrinapp_backend image is available..." -ForegroundColor Cyan
$backendImageExists = docker images peregrinapp_backend -q
if (-not $backendImageExists) {
    # Try to pull from Docker Hub
    Write-Host "Image not found locally, trying to pull from Docker Hub..." -ForegroundColor Yellow
    docker pull peregrinapp_backend 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: peregrinapp_backend image is not available locally or on Docker Hub." -ForegroundColor Red
        Write-Host "Please build the image first and try again." -ForegroundColor Red
        exit 1
    }
}
Write-Host "peregrinapp_backend image is available. Proceeding..." -ForegroundColor Green

# Build the geoserver-with-vectortiles image
Write-Host "Building geoserver-with-vectortiles image..." -ForegroundColor Cyan
docker build -t geoserver-with-vectortiles .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error building geoserver-with-vectortiles image. Exiting." -ForegroundColor Red
    exit 1
}
Write-Host "Successfully built geoserver-with-vectortiles image" -ForegroundColor Green

# Start the docker-compose environment
Write-Host "Starting docker-compose environment..." -ForegroundColor Cyan
docker-compose down
docker-compose up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error starting docker-compose environment. Exiting." -ForegroundColor Red
    exit 1
}
Write-Host "Docker-compose environment started successfully" -ForegroundColor Green

# Wait for services to be ready
Write-Host "Waiting for services to initialize (10 seconds)..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Find the PostGIS backup file and restore it
Write-Host "Looking for PostGIS database backup..." -ForegroundColor Cyan
$postgisBackup = Get-ChildItem -Path . -Filter "postgis_db_*.sql" | Select-Object -First 1
if ($postgisBackup) {
    Write-Host "Found PostGIS backup: $($postgisBackup.Name)" -ForegroundColor Green
    Write-Host "Restoring PostGIS database..." -ForegroundColor Cyan
    & ".\restore_postgis_db.ps1" -backupFile $postgisBackup.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Error during PostGIS database restoration." -ForegroundColor Yellow
    } else {
        Write-Host "PostGIS database restored successfully" -ForegroundColor Green
    }
} else {
    Write-Host "No PostGIS backup file found (postgis_db_*.sql). Skipping restoration." -ForegroundColor Yellow
}

# Find the GeoServer data backup and restore it
Write-Host "Looking for GeoServer data backup..." -ForegroundColor Cyan
$geoserverBackup = Get-ChildItem -Path . -Filter "geoserver_data_*.tar" | Select-Object -First 1
if ($geoserverBackup) {
    Write-Host "Found GeoServer backup: $($geoserverBackup.Name)" -ForegroundColor Green
    Write-Host "Restoring GeoServer data..." -ForegroundColor Cyan
    & ".\restore_geoserver_data.ps1" -backupFile $geoserverBackup.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Error during GeoServer data restoration." -ForegroundColor Yellow
    } else {
        Write-Host "GeoServer data restored successfully" -ForegroundColor Green
    }
} else {
    Write-Host "No GeoServer backup file found (geoserver_data_*.tar). Skipping restoration." -ForegroundColor Yellow
}

# Find and restore backend database
Write-Host "Looking for backend database backup..." -ForegroundColor Cyan
$backendDbBackup = Get-ChildItem -Path . -Filter "backenddb.sql" | Select-Object -First 1
if ($backendDbBackup) {
    Write-Host "Found backend database backup: $($backendDbBackup.Name)" -ForegroundColor Green
    Write-Host "Restoring backend database..." -ForegroundColor Cyan
    & ".\create_backend_database.ps1" -backupFile $backendDbBackup.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Error during backend database restoration." -ForegroundColor Yellow
    } else {
        Write-Host "Backend database restored successfully" -ForegroundColor Green
    }
} else {
    Write-Host "No backend database backup file found (backenddb.sql). Skipping restoration." -ForegroundColor Yellow
}

Write-Host "`nSetup complete! The following services are running:" -ForegroundColor Green
Write-Host "- PostGIS Database: http://localhost:5432" -ForegroundColor Cyan
Write-Host "- GeoServer: http://localhost:8080/geoserver" -ForegroundColor Cyan
Write-Host "- PgAdmin: http://localhost:5050" -ForegroundColor Cyan
Write-Host "- PeregrinApp Backend: http://localhost:3000" -ForegroundColor Cyan 