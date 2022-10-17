---
page_type: sample
languages:
- PowerShell
products:
- Azure AppService
---


# This sample script invokes the Web Apps - Update Configuration REST API to Updates the Auto Heal configurations of a Web App

//DISCLAIMER
//The sample script are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

// Script Overview and Pre-requisites
// This sample script invokes the Web Apps - Update Configuration REST API to Updates the Auto Heal configurations of a Web App
// The same can be done by running the Set-AzureRmResource PS cmdlet
// Before running this, you need to create an Azure Webapp within your Azure Subscription.
// Update all the variable details in the below code before running the script.


$auth=Get-AzAccessToken   
# This command will get the bearer token which will be sent in the Auth header
$authHeader= $auth.token 


# Enable the auto-heal configuration. Modify the Subscription ID and Resource Group and Resource name in the below command

Invoke-WebRequest -UseBasicParsing https://management.azure.com/subscriptions/1234567891012345678910/resourceGroups/MyRG/providers/Microsoft.Web/sites/MyWebAppName/config/web?api-version=2015-08-01 -ContentType "application/json" -Method PUT -Headers @{"Authorization"="Bearer $authHeader"} -Body "{'properties':{'autoHealRules':{'actions':{'customAction':null,'actionType':0,'minProcessExecutionTime':'00:00:20'},'triggers':{'statusCodes':[{'count':10,'status':500,'subStatus':10,'win32Status':121,'timeInterval':'00:01:00','path':'/default.aspx'}],'statusCodesRange':[]}},'autoHealEnabled':true}}"
