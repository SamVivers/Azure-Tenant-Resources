# Azure-Tenant-Resources
Script to identify the resource groups in an azure subscription and export the ARM Template ("ResourceGroup".json) for each. Exports from within the subscription and stores ARM Templates in an external central Azure Storage Account. In the central storage account each subsciption has its own container named "company-subscriptionId" where subscriptionId is the unique Azure Subscription Id and company is a readable identifier cut out of the email of the Azure Subscription (currently only setup to handle .com and .co.uk suffixes).
## Setup
Clone this repo to desired subscriptions Azure CLI
### Env. Var.s
Allow access to external storage account, in Azure CLI (or uncomment and fill out these variables in the script)
```
export AZURE_STORAGE_ACCOUNT="centeral external account name"
```
```
export AZURE_STORAGE_KEY="key to external storage account"
```
using stoarage account key is for testing only will need to tighten up before deployment

### Run the script
```
/bin/bash ./ExistingResourcesARMTemplateExporter.bash
```
Each resource groups ARM Template (ResourceGroup".json) will now reside in the central storage account.
