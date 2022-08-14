//DISCLAIMER
//The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

// Code Overview and Pre-requisites
// This sample code uses the armresources go SDK package to list the Azure Database for MySQL resource details.
// This sample doesn't use the NewListPager function.
// Before running this, you need to create an Azure Database for MySQL in your Azure Subscription.
// Set the environment variables AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_OBJECT_ID
// Use go version go1.18.1 windows/amd64
// Package to be imported are listed in the sample code below.
// Update all the variable details in the below code before running the sample.


//Sample Code

package main

import (
	"context"
	"log"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
)

var (
	subscriptionID    string
	location          = "Region"
	resourceGroupName = "MyRGName"
	mySQLName         = "MySQLName"
)

func main() {
	subscriptionID = "XXXX-XXXXXX-XXXX-XXXX"
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

	genericResource, err := getResource(ctx, cred)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Get resource ID:", *genericResource.ID)
	log.Println("Kind:", *genericResource.Kind)
	log.Println("Location:", *genericResource.Location)
	log.Println("State:", *&genericResource.Properties)

}

var resourceProviderNamespace = "Microsoft.DBforMySQL"
var resourceType = "servers"
var apiVersion = "2017-12-01-preview"

func getResource(ctx context.Context, cred azcore.TokenCredential) (*armresources.GenericResource, error) {
	resourceClient, err := armresources.NewClient(subscriptionID, cred, nil)

  // Get the resource details
	resp, err := resourceClient.Get(
		ctx,
		resourceGroupName,
		resourceProviderNamespace,
		"/",
		resourceType,
		mySQLName,
		apiVersion,
		nil)
	if err != nil {
		return nil, err
	}

	return &resp.GenericResource, nil
}
