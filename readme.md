# PeregrinApp GeoServer Infrastructure

## Building and Running the Infrastructure

The infrastructure uses Docker Compose to run multiple services. The `build_and_run.ps1` script automates the process of building and starting all required containers:

1. Checks if Docker is running
2. Verifies the peregrinapp_backend image exists (tries to pull from Docker Hub if not found locally)
3. Builds the custom geoserver-with-vectortiles image
4. Starts the Docker Compose environment with the following services:
   - PostGIS database (PostgreSQL with spatial extensions)
   - GeoServer (with vector tiles support)
   - pgAdmin web interface
   - PeregrinApp backend service


## Docker Backup and Restore Scripts

This repository contains PowerShell scripts for backing up and restoring PostgreSQL and GeoServer data from Docker containers. These scripts allow you to easily transfer your data between different environments or create backups of your current state.

### Prerequisites

- Windows with PowerShell
- Docker installed and running
- Docker containers running with the following names:
  - `postgis` (PostgreSQL/PostGIS container)
  - `geoserver` (GeoServer container)

### PostgreSQL/PostGIS Backup and Restore

#### Backup PostgreSQL Database

The `backup_postgis_db.ps1` script creates a SQL dump of your PostgreSQL database.

```powershell
# Basic usage (uses default settings)
.\backup_postgis_db.ps1

# Custom settings
.\backup_postgis_db.ps1 -dbname "different_db" -username "different_user" -password "different_password"
```

Default settings:
- Database: geodata
- Username: admin
- Password: admin
- Container: postgis

The backup file will be created in the current directory with the name format: `postgis_db_YYYYMMDD_HHMMSS.sql`

#### Restore PostgreSQL Database

The `restore_postgis_db.ps1` script restores a previously created backup.

```powershell
# Basic usage
.\restore_postgis_db.ps1 -backupFile "postgis_db_20240321_143000.sql"

# Custom settings
.\restore_postgis_db.ps1 -backupFile "postgis_db_20240321_143000.sql" `
                        -dbname "different_db" `
                        -username "different_user" `
                        -password "different_password"
```

The script will:
1. Terminate existing connections
2. Drop the existing database
3. Create a new database
4. Restore the backup

### GeoServer Backup and Restore

#### Backup GeoServer Data

The `backup_geoserver_data.ps1` script creates a compressed archive of your GeoServer data directory.

```powershell
# Basic usage (uses default settings)
.\backup_geoserver_data.ps1

# Custom settings
.\backup_geoserver_data.ps1 -container "different_geoserver" -geoserver_data_dir "/different/path"
```

Default settings:
- Container: geoserver
- Data directory: /opt/geoserver_data

The backup file will be created in the current directory with the name format: `geoserver_data_YYYYMMDD_HHMMSS.tar.gz`

#### Restore GeoServer Data

The `restore_geoserver_data.ps1` script restores a previously created GeoServer backup.

```powershell
# Basic usage
.\restore_geoserver_data.ps1 -backupFile "geoserver_data_20240321_143000.tar.gz"

# Custom settings
.\restore_geoserver_data.ps1 -backupFile "geoserver_data_20240321_143000.tar.gz" `
                            -container "different_geoserver" `
                            -geoserver_data_dir "/different/path"
```

The script will:
1. Copy the backup to the container
2. Clear the existing data directory
3. Extract the backup
4. Restart the GeoServer container

**Note**: After restoration, GeoServer will restart automatically. Please wait a few moments for it to become fully operational.

### Important Notes

1. Always ensure you have enough disk space for backups
2. Test the restore process in a non-production environment first
3. Keep your backup files secure as they contain sensitive configuration data
4. The backup files can be used to transfer data between different Docker environments
5. Make sure the target containers are running before executing the scripts

### Troubleshooting

If you encounter any errors:

1. Check that the containers are running:
```powershell
docker ps
```

2. Verify the container names match your environment
3. Ensure you have proper permissions to execute the scripts
4. Check that the backup file exists and is readable when restoring
5. Make sure you have enough disk space for the backup/restore operation