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
#	echo "$k.txt created"
	az group export -n "$k" > "$k".json
	echo "$k.json created"
done 

# cut the email address of the Azure Subscription to just the company name, then create storage container with this name 
# export AZURE_STORAGE_ACCOUNT=
# export AZURE_STORAGE_KEY=
SubscriptionName=`az account list --query [].user.name -o tsv`
# echo $AccountName
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
az storage container create --name $UserName --account-name $AZURE_STORAGE_ACCOUNT

# upload files to created container (with current date appended to the name) 
now=`date`
for l in ${ResourceGroupArray[@]}; do 
	az storage blob upload --container-name $UserName --file "$l.json" --name "$l ARMTemplate $now" --account-name $AZURE_STORAGE_ACCOUNT
done
# az storage blob list --container-name $UserName --account-name $AZURE_STORAGE_ACCOUNT --o table

# clean up
for m in ${ResourceGroupArray[@]}; do
	rm "$m.json"
done
