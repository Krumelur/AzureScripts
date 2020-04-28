###########################################################################
# This script generates a CosmosDB instance with a database and a container
# and returns the connection string
###########################################################################

# This will trigger a browser-based login.
az login

# Variables
#suffix=$RANDOM
#cosmosDbInstanceName="dbbacktoschool$suffix"
cosmosDbInstanceName="COSMOSDB INSTANCE NAME HERE"
databaseName="NAME OF DB TO CREATE"
containerName="NAME OF CONTAINER TO CREATE"
location="centralus"
resourceGroup="NAME OF RESOURCE GROUP TO USE"

# Set defaults for all following commands
az configure --defaults group=$resourceGroup
az configure --defaults location=$location 

printf "Creating a CosmosDB instance named '%s'...this can take long. I mean, really long.\n" $cosmosDbInstanceName
az cosmosdb create --name $cosmosDbInstanceName

# Create a database.
printf "Creating a database named '%s' in the instance '%s'\n" $databaseName $cosmosDbInstanceName
az cosmosdb sql database create --name $databaseName --account-name $cosmosDbInstanceName

# Create a container in the database
printf "Creating a container named '%s' in database '%s'.\n" $containerName $databaseName
az cosmosdb sql container create --name $containerName --partition-key-path /id --account-name $cosmosDbInstanceName --database-name $databaseName

# Get the primary connection string
printf "Getting primary connection string for instance '%s'.\n" $cosmosDbInstanceName
connectionString=$(az cosmosdb keys list --name $cosmosDbInstanceName --type connection-strings --query 'connectionStrings[0].connectionString' --output tsv)
printf "Use this connection string:\n\n%s\n\n" $connectionString