---
page_type: sample
languages:
- powershell
products:
- azure-storage	
---


# Powershell script to list the Azure Resources that is using Azure Storage Account

 Code Overview and Pre-requisites
 
 This powershell sample script helps to fetch the Azure Resources in your subscription that is using the Azure Storage Account.
 You need to update the subscription ID in the below PS script.
 Before running the sample ensure that you have the necessary Azure PowerShell modules installed.
 ```
  Install-Module -Name Az.Accounts
  Install-Module -Name Az.Resources
  Install-Module -Name Az.Storage
 ```
 
 Update all the variable details in the below script before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
# Login to Azure
Connect-AzAccount

# Select the concerned subscription ID
Select-AzSubscription -SubscriptionId 'XXXXXXX'

Write-Output "`r`n"

# Get all resources in the subscription
$resources = Get-AzResource
 
# Loop through each resource and check if it has Azure monitor with storage diagnostic enabled
foreach ($resource in $resources) {
    $resourceName = $resource.Name
    $resourceType = $resource.ResourceType
    $resourceId = $resource.ResourceId

 
    # Check if the resource has Azure monitor with storage diagnostic enabled
    $diagnosticSettings = Get-AzDiagnosticSetting -ResourceId $resourceId -ErrorAction SilentlyContinue
    if ($diagnosticSettings -ne $null -and $diagnosticSettings.StorageAccountId -ne $null) {
        # If it has Azure monitor with storage diagnostic enabled, get the storage account name
        $storageAccountId = $diagnosticSettings.StorageAccountId
       # $storageAccountName = (Get-AzStorageAccount -ResourceGroupName $resource.ResourceGroupName -Name $storageAccountId.Split("/")[-1]).StorageAccountName

        # Output the resource name and storage account name
        Write-Output "$resourceId of Type ($resourceType) has Azure monitor with storage diagnostic enabled. Storage account ID: $storageAccountId"
        Write-Output "`r`n"
        
    }
}

```
