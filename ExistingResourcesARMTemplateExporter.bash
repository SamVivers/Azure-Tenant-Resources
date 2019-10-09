#!/bin/bash

k=0
s=5
j=0

export AZURESTACK_RESOURCE_GROUP=<resourcegroupname> 
export AZURESTACK_RG_LOCATION=<location>
export AZURESTACK_STORAGE_ACCOUNT_NAME=<uniquestorageaccountname>
export AZURESTACK_STORAGE_CONTAINER_NAME=<uniquestoragecontainername>
export AZURESTACK_STORAGE_BLOB_NAME=<uniqueblobname>
export FILES_TO_UPLOAD=
export DESTINATION_FILES=<destinationfilestest>

# list resource groups
ResourceGroupList=`az group list --query [].name --output json`
# cut result into individual resource group names and remove extra characters, then place these into an array
declare -a ResourceGroupArray

for (( i=0; i<${#ResourceGroupList}; i++ )); do
	if [ "${ResourceGroupList:i:1}" == "," ]; then
		ResourceGroupArray[$j]="${ResourceGroupList:s:i-(s+1)}"
		s=$i+5
		j=$j+1
	fi
	if [ "${ResourceGroupList:i:1}" == "]" ]; then
		ResourceGroupArray[$j]="${ResourceGroupList:s:i-(s+2)}"
	fi
done
# echo ${ResourceGroupArray[@]}

# export the ARM Template for each resource group
for k in ${ResourceGroupArray[@]}; do	
#	az group export -n "$k" -o table > "$k".txt
	az group export -n "$k" > "$k".json
	echo "$k.json created"
done 

echo "Creating resource group"
az group create --name $AZURESTACK_RESOURCE_GROUP --location $AZURESTACK_RG_LOCATION

echo "Creating the storage account"
az storage account create --name $AZURESTACK_STORAGE_ACCOUNT_NAME --resource-group $AZURESTACK_RESOURCE_GROUP 

echo "Creating the blob container"
az storage container create --name $AZURESTACK_STORAGE_CONTAINER_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME

echo "Uploading the files"
for l in ${ResourceGroupArray[@]}; do 
	echo "$l".json
		 az storage blob upload --container-name $AZURESTACK_STORAGE_CONTAINER_NAME --file "$l".json --name $l --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME

done

echo "Listing the blobs"
az storage blob list --container-name $AZURESTACK_STORAGE_CONTAINER_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME --output table


