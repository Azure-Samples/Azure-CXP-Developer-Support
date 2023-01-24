---
page_type: sample
languages:
- powershell
products:
- azure-cost-management
description: "PowerShell sample script to list billing accounts."
---


# PowerShell script to list billing accounts using Rest API

## Script Overview 
 
 This sample script invokes the REST API directly to list the billing Accounts using PowerShell.
 
 ## Pre-requisites
 Before running this, we will need to assign permissions on the targeted Billing Account. To do this, go to the `Cost Management + Billing` blade in Azure Portal --> `Billing Scopes` --> Select your desired billing account --> then `Access Control (IAM)` to grant any one permissions to view billing accounts.
 
 >[!NOTE]
 > Granting permission on a billing account is different than assigning the **Billing Reader** permission at the Subscription scope. A **Billing Reader** will be able to download or manage **only** invoices of the Subscription, not the billing accounts.
 
 Update all the variable details in the below code before running the sample.
 
## DISCLAIMER

The sample script are not supported under any Microsoft standard support program or service. The sample script are provided **AS IS** without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages. 

```
# Sample Script

$tenantId = "XXXXXXXXX"
$applicationId = "XXXXXXXXX"
$secret = "XXXXXXXXX"
$apiEndpointUri = "https://management.azure.com/" 

$RequestAccessTokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/token"
$body = "grant_type=client_credentials&client_id=$($applicationId)&client_secret=$($secret)&resource=$($apiEndpointUri)" 

$AccessToken = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $body -ContentType 'application/x-www-form-urlencoded'

$output= Invoke-WebRequest -UseBasicParsing https://management.azure.com/providers/Microsoft.Billing/billingAccounts?api-version=2020-05-01 -Headers @{"Authorization"="Bearer $AccessToken.access_token"}

$response = ConvertFrom-Json $output.Content -ErrorAction SilentlyContinue

echo $response

```
