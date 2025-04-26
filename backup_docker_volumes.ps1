# backup-docker-volumes.ps1

param (
    [string]$namespace
)

if (-not $namespace) {
    Write-Host "Please provide the namespace (project name) as a parameter."
    exit
}

$backupDir = (Get-Location).Path
Write-Host "Backing up Docker volumes with namespace '$namespace' to $backupDir`n"

# GeoServer volume backup
docker run --rm -v "${namespace}_geoserver_data:/data" -v "${backupDir}:/backup" alpine tar czf /backup/${namespace}_geoserver_data.tar.gz -C /data .
Write-Host "✔ ${namespace}_geoserver_data volume backed up to ${namespace}_geoserver_data.tar.gz"

# PostGIS volume backup
docker run --rm -v "${namespace}_postgis_data:/data" -v "${backupDir}:/backup" alpine tar czf /backup/${namespace}_postgis_data.tar.gz -C /data .
Write-Host "✔ ${namespace}_postgis_data volume backed up to ${namespace}_postgis_data.tar.gz"