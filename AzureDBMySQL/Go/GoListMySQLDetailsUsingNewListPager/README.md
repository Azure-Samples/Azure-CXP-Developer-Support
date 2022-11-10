---
page_type: sample
languages:
- Go
products:
- azure-database-mysql
---


# Go sample code uses the armresources go SDK package to list the Azure Database for MySQL resource details.



Code Overview and Pre-requisites

 This sample code uses the armresources go SDK package to list the Azure Database for MySQL resource details.
 This sample uses the NewListPager function.
 Before running this, you need to create an Azure Database for MySQL in your Azure Subscription.
 Set the environment variables AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_OBJECT_ID
 Use go version go1.18.1 windows/amd64
 Package to be imported are listed in the sample code below.
 Update all the variable details in the below code before running the sample.


DISCLAIMER

The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

```
//Sample Code

package main

import (
	"context"
	"log"
	"strings"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
)

var (
	subscriptionID string
	server         string
	location       = "region"
	resourceGroupName         = "MyRgName"
	serverName                = "MySQLName"
	resourceProviderNamespace = "Microsoft.DBforMySQL"
	resourceType              = "servers"
	apiVersion                = "2017-12-01-preview"
)

func main() {
	subscriptionID = "XXXXX-XXXXX-XXXX-XXXXX"
	if len(subscriptionID) == 0 {
		log.Fatal("AZURE_SUBSCRIPTION_ID is not set.")
	}
  
  // To configure DefaultAzureCredential to authenticate a user-assigned managed identity, 
  // set the environment variable AZURE_CLIENT_ID to the identity's client ID.

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		log.Fatal(err)
	}
	ctx := context.Background()

  // Azure SDK Azure Resource Management clients accept the credential as a parameter
	client2, err := armresources.NewClient(subscriptionID, cred, nil)
	if err != nil {
		log.Printf("Error creating client: %v\n", err)
	}

  // Get all the resources in a subscription. If the operation fails it returns an *azcore.ResponseError type.
	pager := client2.NewListPager(nil)
	for pager.More() {
		page, err := pager.NextPage(ctx)
		if err != nil {
			log.Printf("Error getting next page: %v\n", err)
		}

		for _, item := range page.Value {
			if strings.Contains(*item.Type, "Microsoft.DBforMySQL") {
				log.Println(*&item.Properties)
			}
		}
	}

}
```
