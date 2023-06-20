---
page_type: sample
languages:
- powershell
products:
- azure-cost-management
description: "PowerShell sample script to query the cost management details."
---


# PowerShell script to query the cost management details of the subscription

## Script Overview 
 
 This sample script invokes the cost-management REST API directly to query the cost details of the subscription.
 
 ## Pre-requisites 
Update all the variable details in the below code before running the sample.
 
## DISCLAIMER

The sample script are not supported under any Microsoft standard support program or service. The sample script are provided **AS IS** without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages. 

```
# Sample Script

# Azure subscription ID
$subscriptionId = ''

# URI endpoint for Azure Cost Management API
$uri = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.CostManagement/query?api-version=2021-10-01" $token = $(Get-AZAccessToken).Token $securetoken = ConvertTo-SecureString $token -AsPlainText -Force

#Grouping by dimension, servicename and  Building request body
$body = @{
    type = 'Usage'
    timeframe = 'MonthToDate'
    dataset = @{
        granularity = 'Daily'
        aggregation = @{
            totalCost = @{
                name = 'PreTaxCost'
                function = 'Sum'
            }
        }
        grouping = @(
            @{
                type = 'Dimension'
                name = 'ServiceName'
            }
        )
      
    }
}

# Send API request and store response
$costresponse = Invoke-WebRequest -Uri $uri -Method Post -Authentication Bearer -Token $securetoken -Body ($body|ConvertTo-Json -Depth 5) -ContentType 'application/json'

```
