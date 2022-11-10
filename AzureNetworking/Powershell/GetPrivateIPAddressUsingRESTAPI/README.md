---
page_type: sample
languages:
- powershell
products:
- azure-firewall
---

# PowerShell script invokes the Azure Firewalls - GET REST API  to display the hubIPAddresses details.

 Script Overview and Pre-requisites
 
 This powershell script invokes the Azure Firewalls - GET REST API  to display the hubIPAddresses details.
 Note that the same can be accomplished by running the PS Get-AzFirewall cmdlet.
 Before running this, you need to create an Azure Firewall within your Azure Subscription.
 Update all the variable details within the below script before running the sample.
 
 DISCLAIMER
 The sample script are not supported under any Microsoft standard support program or service. The sample script are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages


```
# Sample Script

$auth=Get-AzAccessToken
$authHeader= $auth.token 
$subscriptionId='XXXXXXXXXXXXX
$resourceGroupName='RGName'
$firewallName='FirewallName'
$uri= "https://management.azure.com/subscriptions/" + $subscriptionId + "/resourceGroups/" + $resourceGroupName + "/providers/Microsoft.Network/azureFirewalls/" + $firewallName + "?api-version=2021-08-01"
$output=Invoke-WebRequest -Uri $uri -Method GET -Headers @{"Authorization"="Bearer $authHeader"}
$output | ConvertFrom-Json | select -ExpandProperty properties  | select -ExpandProperty hubIPAddresses | Format-List
```
