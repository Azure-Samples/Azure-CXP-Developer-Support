---
page_type: sample
languages:
- powershell
products:
- billing
---


# PS script to List Billing Accounts using Rest API

Script Overview and Pre-requisites
 
 This sample script invokes the REST API directly to List the Billing Accounts from PowerShell.
 Before running this, One has to go to `Cost Management + Billing` blade in Azure Portal --> `Billing Scopes` --> Select any billing account --> Access Control blade IAM to grant any one permissions to view billing accounts.
 Remember that a Billing Reader, it’s a permissions available at Subscription scope. Once a user grants this permission, they will be able to download or manage only invoices of the subscription (below), not the billing accounts.
 The permissions needed to view the billing account is different from the permissions to control at subscription. BillingReader or any custom role is a RBAC permission on Subscription scope and they have no significance or impact on controlling/managing billing accounts.
 Update all the variable details in the below code before running the sample.
 
DISCLAIMER

The sample script are not supported under any Microsoft standard support program or service. The sample script are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

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
