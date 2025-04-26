# build_custom_geoserver.ps1
param (
    [string]$tag = "geoserver-with-vectortiles"
)

Write-Host "Building Docker image with tag '$tag' from current directory..."

docker build -t $tag .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Image '$tag' built successfully."
} else {
    Write-Host "❌ Failed to build the Docker image." -ForegroundColor Red
}