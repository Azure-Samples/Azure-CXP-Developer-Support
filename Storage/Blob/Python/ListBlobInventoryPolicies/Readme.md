---
page_type: sample
languages:
- python
products:
- azure-storage	
---


# Python sample code to perform a management operation to check the Storage account type and list the Blob Inventory rules.

 Code Overview and Pre-requisites
 
 This sample code uses the azure.mgmt.storage python module to perform the management operation to check the type of storage account ( v1 or v2 ). If the account is v2 it will retrieve the Blob Inventory policy details.
 Before running this, you need to ensure that the Azure Blob Storage is created and have the Blob inventory policy created.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 



//Sample Code

```
from azure.identity import DefaultAzureCredential
from azure.mgmt.storage import StorageManagementClient


# Set your Azure subscription ID
subscription_id = 'XXXXXXXXXXXXXXXXXXXXXXX'

# Set your Azure credentials
credential = DefaultAzureCredential()

# Create the StorageManagementClient
client = StorageManagementClient(credential, subscription_id)

# Set your resource group name and storage account name
resource_group_name = 'Storage-ResourceGroup'
storage_account_name = 'StorageAccountName'


# Get the storage account properties
storage_account = client.storage_accounts.get_properties(
    resource_group_name, storage_account_name
)

# Retrieve the storage kind
storage_kind = storage_account.kind

# Check if it is GPv1 or GPv2
if storage_kind.startswith("StorageV2"):
    print("Storage account is using GPv2")
    # List blob inventory policies
    policies = client.blob_inventory_policies.list(resource_group_name, storage_account_name)
    for policy in policies:
        print(f"Policy ID: {policy.id}")
        print(f"Policy Name: {policy.name}")
        print(f"Policy Enabled: {policy.enabled}")
elif storage_kind.startswith("Storage"):
    print("Storage account is using GPv1")

```
