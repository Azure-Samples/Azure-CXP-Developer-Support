---
page_type: sample
languages:
- go
products:
- azure-cost-management
---


# Go sample code to query the cost of Azure Virtual Machine within the subscription.

 Code Overview and Pre-requisites
 
 This sample code uses the [costmanagement](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/services/preview/costmanagement/mgmt/2019-03-01/costmanagement) package to query the cost of the Azure VM.
 Howevevr, this package is now deprecated and it is recommended to use the replace package [armcostmanagement](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/costmanagement/armcostmanagement).
 Before running this, you need to create an Azure VM within your Azure Subscription.
 Use go version go1.18.1 windows/amd64. Package to be imported are listed in the sample code below.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

package main

import (
	"context"
	"fmt"

	"github.com/Azure/azure-sdk-for-go/services/costmanagement/mgmt/2020-06-01/costmanagement"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/Azure/go-autorest/autorest/to"
)

func main() {

	subscriptionID := "XXXXXXXXXXXXXXXX"
	clientID := "XXXXXXX"
	clientSecret := "XXXXXXXXXXXXXXXXXXX"
	tenantID := "XXXXXXXXXXXXXXX"

	scope := "/subscriptions/XXXXXXXXXXXXXXX/resourceGroups/RGName"

	// Define AAD service principal credentials
	spConfig := auth.NewClientCredentialsConfig(clientID, clientSecret, tenantID)
	authorizer, err := spConfig.Authorizer()

	if err != nil {
		// handle error
	}

	costQueryClient := costmanagement.NewQueryClient(subscriptionID)
	costQueryClient.Authorizer = authorizer
	queryAggregation := make(map[string]*costmanagement.QueryAggregation)
	queryAggregation["totalCost"] = &costmanagement.QueryAggregation{
		Name:     to.StringPtr("PreTaxCost"),
		Function: to.StringPtr("Sum"),
	}
	queryAggregation["totalCostUSD"] = &costmanagement.QueryAggregation{
		Name:     to.StringPtr("PreTaxCostUSD"),
		Function: to.StringPtr("Sum"),
	}

	queryDefinition := costmanagement.QueryDefinition{
		Type:      costmanagement.ExportTypeActualCost,
		Timeframe: costmanagement.TimeframeTypeMonthToDate,
		Dataset: &costmanagement.QueryDataset{
			Granularity: costmanagement.Daily,
			Aggregation: queryAggregation,
			Filter: &costmanagement.QueryFilter{
				And: &[]costmanagement.QueryFilter{
					{
						Dimension: &costmanagement.QueryComparisonExpression{
							Name:     to.StringPtr("ResourceType"),
							Operator: to.StringPtr("In"),
							Values:   to.StringSlicePtr([]string{"Microsoft.Compute/virtualMachines"}),
						},
					},
					{
						Dimension: &costmanagement.QueryComparisonExpression{
							Name:     to.StringPtr("ResourceId"),
							Operator: to.StringPtr("In"),
							Values:   to.StringSlicePtr([]string{"/subscriptions/XXX/resourceGroups/RGName/providers/Microsoft.Compute/virtualMachines/VMName"}),
						},
					},
				},
			},
		},
	}

	// result, err := costQueryClient.Usage() Usage() Usage() context.Background(),  , queryDefinition)
	result, err := costQueryClient.Usage(context.Background(), scope, queryDefinition)

	// print the result
	if err != nil {
		// handle error
	}

	fmt.Printf("result: %v\n", result)

}


```
