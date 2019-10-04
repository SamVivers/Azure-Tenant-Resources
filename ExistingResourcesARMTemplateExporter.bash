#!/bin/bash

# list resource groups
ResourceGroupList=`az group list --query [].name --output json`

# cut result into individual resource group names and remove extra characters, then place these into an array
declare -a ResourceGroupArray
s=5
j=0
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
#	echo ${ResourceGroupArray[@]}

# export the ARM Template for each resource group
for k in ${ResourceGroupArray[@]}; do	
	az group export -n "$k" > "$k".json
	echo "$k.json created"
# simple overview of resources
#       az group export -n "$k" -o table > "$k".txt
# 	echo "$k.txt created"
done 
