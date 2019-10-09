# Azure-Tenant-Resources
Script to identify the resource groups in an azure subscription and export the ARM Template ("ResourceGroup".json) for each. Exports from  within the subscription and stores ARM Templates in an external cental Azure Storage Account

### Env. Var.s
Allow access to external storage account, in Azure CLI
```
export AZURE_STORAGE_ACCOUNT="centeral external account name"
```
```
export UserName="Company who's subscription it is"
```
```
export AZURE_STORAGE_KEY="key to external storage account"
```
using stoarage account key is for testing only will need to tighten up before deployment

### Run the script
Clone this repo to your subscriptions Azure CLI then
```
/bin/bash ./ExistingResourcesARMTemplateExporter.bash
```
Each resource groups ARM Template (ResourceGroup".json) will now reside in the central storage account.
