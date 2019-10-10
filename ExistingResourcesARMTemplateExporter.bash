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
#	echo "creating $k.txt"
#	az group export -n "$k" -o table > "$k".txt
#	echo "$k.txt created"
	echo "creating $k.json"
	az group export -n "$k" > "$k".json
	echo -e "$k.json created\n"
done 

# cut the email address of the Azure Subscription to just the company name, then check if a container already exists, if not create storage container with this name and unique subscription id
export AZURE_STORAGE_ACCOUNT="storageaccountytest"
export AZURE_STORAGE_KEY=`az keyvault secret show -n StorageAccountKey --vault-name keyvaultdatatest --query value -o tsv`
SubscriptionName=`az account list --query [].user.name -o tsv`
# echo $SubscriptionName
for (( i=0; i<${#SubscriptionName}; i++ )); do
        if [ "${SubscriptionName:i:1}" == "@" ]; then
                EmailName="${SubscriptionName:i+1:${#SubscriptionName}}"
        fi
done
for (( i=0; i<${#EmailName}; i++ )); do
        if [ "${EmailName:i:3}" == ".co" ]; then
                UserName="${EmailName:0:i}"
        fi
done
# echo $UserName
UserId=`az account list --query [].id -o tsv`
ContainerName="$UserName-$UserId"
if [ `az storage container exists --account-name $AZURE_STORAGE_ACCOUNT --name $ContainerName -o tsv` == "False" ]; then
	echo "creating storage container $ContainerName"
	az storage container create --name $ContainerName --account-name $AZURE_STORAGE_ACCOUNT -o tsv
	echo -e "$ContainerName created\n"
fi

# upload files to created container (with current date appended to the name) 
now=`date +'%Y/%m/%d %H:%M:%S'`
for l in ${ResourceGroupArray[@]}; do 
	echo "uploading $l.json"
	az storage blob upload --container-name $ContainerName --file "$l.json" --name "$now $l ARMTemplate " --account-name $AZURE_STORAGE_ACCOUNT
	echo -e "$l.json uploaded\n"
done
az storage blob list --container-name $ContainerName --account-name $AZURE_STORAGE_ACCOUNT --o table

# clean up
for m in ${ResourceGroupArray[@]}; do
	rm "$m.json"
done
