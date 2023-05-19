---
page_type: sample
languages:
- Go
products:
- azure-virtual-machines	
---


# Go sample code to filter and list the Azure Virtual Machines in a subscription based on resource tags.


 ## Code Overview
 
 This sample code uses the armresourcegraph SDK for Go package to filter the Azure VMs based on the tags and then list those VMs within a subscription.
 
 ##  Pre-requisites
 Before running this, you need to: 
 - Create an Azure Virtual Machine in your Azure Subscription and add the relevant resource tags to it.
 - Set the environment variables `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_OBJECT_ID`.
 - Use go version `go1.18.1 windows/amd64`. The packages to be imported are listed in the sample code below.
 - Update all the variable details in the below code before running the sample.


## DISCLAIMER

The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided **AS IS** without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages. 

```
// Sample Code

package main

import (
	"context"
	"fmt"
	"log"
	"strconv"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resourcegraph/armresourcegraph"
)

var (
	subscriptionID string
	TenantID       string
)

func main() {

	// To configure DefaultAzureCredential to authenticate a user-assigned managed identity,
	// set the environment variable AZURE_CLIENT_ID to the identity's client ID.

	clientID := "XXXXXXXXXXXXXXXX"
	clientSecret := "XXXXXXXXXXXXXXXX"
	tenantID := "XXXXXXXXXXXXXXXX"

        // Constructs a ClientSecretCredential. Pass nil for options to accept defaults.
	cred, err := azidentity.NewClientSecretCredential(tenantID, clientID, clientSecret, nil)
	if err != nil {
		log.Fatalf("failed to create credential: %v", err)
	}

	ctx := context.Background()

	// Create and authorize a ResourceGraph client
	client, err := armresourcegraph.NewClient(cred, nil)
	if err != nil {
		log.Fatalf("failed to create client: %v", err)
	}

	// Create the query request, Run the query and get the results. Update the Tags and subscriptionID details below.
	results, err := client.Resources(ctx,
		armresourcegraph.QueryRequest{
			Query: to.Ptr("Resources | where type =~ 'Microsoft.Compute/virtualMachines' and tags.Environment=~ 'Production' | project name, type, location, properties"),
			Subscriptions: []*string{
				to.Ptr("XXXXXXXXXXXXXXXXXXXX")},
		},
		nil)
	if err != nil {
		log.Fatalf("failed to finish the request: %v", err)
	} else {
		// Print the obtained query results
		fmt.Printf("Resources found: " + strconv.FormatInt(*results.TotalRecords, 10) + "\n")
		fmt.Printf("Results: " + fmt.Sprint(results.Data) + "\n")
	}

}

```
