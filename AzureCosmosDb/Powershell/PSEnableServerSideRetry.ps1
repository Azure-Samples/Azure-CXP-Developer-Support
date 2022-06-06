#DISCLAIMER
#The sample scripts are not supported under any Microsoft standard support program or service. The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


#Script Overview and Pre-requisites
# This script invokes the rest api to turn on the server-side retry feature of Azure CosmosDB API for MangoDb account
# Before running this, you need to create an Azure CosmosDB API for MangoDb account
# Install and import Az.Accounts module

#Sample Script

# This command will get the bearer token which will be sent in the Auth header
$auth=Get-AzAccessToken   
$authHeader= $auth.token 

# Disable Server Side Retry feature. Modify the Subscription ID and Resource Group and Resource name in the below command:
$output= Invoke-WebRequest -UseBasicParsing https://management.azure.com/subscriptions/1234567891011121314/resourceGroups/MyRGName/providers/Microsoft.DocumentDb/databaseAccounts/Name-mongodb/?api-version=2022-02-15-preview -ContentType "application/json" -Method PATCH -Headers @{"Authorization"="Bearer $authHeader"} -Body "{'properties':{'capabilities':[{'name':'EnableMongo'}]}}"

# Enable Server Side Retry feature.  Modify the Subscription ID and Resource Group and Resource name in the below command:
$output= Invoke-WebRequest -UseBasicParsing https://management.azure.com/subscriptions/1234567891011121314/resourceGroups/MyRGName/providers/Microsoft.DocumentDb/databaseAccounts/Name-mongodb/?api-version=2022-02-15-preview -ContentType "application/json" -Method PATCH -Headers @{"Authorization"="Bearer $authHeader"} -Body "{'properties':{'capabilities':[{'name':'DisableRateLimitingResponses'},{'name':'EnableMongo'}]}}"

