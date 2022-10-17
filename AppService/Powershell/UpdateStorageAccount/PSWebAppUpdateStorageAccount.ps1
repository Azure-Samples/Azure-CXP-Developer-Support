# DISCLAIMER
# The sample script are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

# Script Overview and Pre-requisites
# This sample script invokes the Web Apps - Update Azure Storage Accounts REST API to Updates the Azure storage account configurations of an app
# Before running this, you need to create an Azure Storage account and Azure Webapp within your Azure Subscription.
# The same can be achieved using PS Set-AzWebApp cmdlet by setting AzureStoragePath parameter
# Update all the variable details in the below code before running the script.


# Sample Script

$auth=Get-AzAccessToken   # This command will get the bearer token which will be sent in the Auth header
$authHeader= $auth.token 

# Link the Azure Storage with Webapp. Modify the Subscription ID and Resource Group and Resource name in the below command
$output= Invoke-WebRequest -UseBasicParsing https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{name}/config/azurestorageaccounts?api-version=2022-03-01 -Method PUT -Headers @{"Authorization"="Bearer $authHeader"} -Body "'properties':{'kmp':{'type':'AzureBlob','accountName':'stYYYYY','shareName':'cf3-YYYYY-kmp','accessKey':'YYYYY==','mountPath':'/opt/toto','state": 'NotValidated'}}"
