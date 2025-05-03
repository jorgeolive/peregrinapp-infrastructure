# Variables
$containerName = "postgis"
$sqlFile = "backenddb.sql"
$containerSqlPath = "/init.sql"
$dbUser = "admin"
$dbName = "geodata"

# Copy the SQL file into the container
docker cp $sqlFile "${containerName}:${containerSqlPath}"

# Execute the SQL script inside the container
docker exec -it $containerName psql -U $dbUser -d $dbName -f $containerSqlPath