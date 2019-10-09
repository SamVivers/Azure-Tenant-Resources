# Azure-Tenant-Resources
Script to identify the resource groups in an azure subscription and export the ARM Template: "ResourceGroup".json for each

Env. Var.s

create a storage account and run these in you Azure cli to access storage

export AZURE_STORAGE_ACCOUNT="your unique account name"

export AZURE_STORAGE_KEY=`az storage account keys list -n $AZURE_STORAGE_ACCOUNT -o tsv --query "[?contains(keyName, 'key1')].value"`
