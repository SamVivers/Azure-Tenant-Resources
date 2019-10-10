# Azure-Tenant-Resources
Script to identify the resource groups in an azure subscription and export the ARM Template ("ResourceGroup".json) for each. Exports from within the subscription and stores ARM Templates in our external central Azure Storage Account. In the central storage account each subsciption has its own container named "company-subscriptionId" where subscriptionId is the unique Azure Subscription Id and company is a readable identifier cut out of the email of the Azure Subscription (currently only setup to handle .com and .co.uk suffixes).
## Setup
Clone this repo to desired subscriptions Azure CLI
### Run the script
```
/bin/bash ./ExistingResourcesARMTemplateExporter.bash
```
Each resource groups ARM Template (ResourceGroup".json) will now reside in the central storage account.
