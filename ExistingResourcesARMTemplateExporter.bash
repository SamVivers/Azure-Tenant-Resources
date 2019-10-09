#!/bin/bash

# list resource groups
ResourceGroupList=`az group list --query [].name --output json`
# cut result into individual resource group names and remove extra characters, then place these into an array
declare -a ResourceGroupArray
j=0
s=5
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

echo "Uploading the files"
for l in ${ResourceGroupArray[@]}; do 
	az storage blob upload --container-name $AZURE_STORAGE_CONTAINER --file "$l.json" --name "$l ARMTemplate" --account-name $AZURE_STORAGE_ACCOUNT
done

echo "Listing the blobs"
az storage blob list --container-name $AZURE_STORAGE_CONTAINER --account-name $AZURE_STORAGE_ACCOUNT --o table
