---
page_type: sample
languages:
- Go
products:
- azure-resource-manager
---


# Go sample code lists the cluster admin credentials for your AKS cluster.


 Code Overview and Pre-requisites
 
 This sample code lists the cluster admin credentials for your AKS cluster.
 Before running this, you need to create an AKS cluster and ensure that Azure Kubernetes Service Cluster Admin Role permission is provided for your Service Principal
 Set the environment variables AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_OBJECT_ID
 Use go version go1.18.1 windows/amd64
 Package to be imported are listed in the sample code below.


DISCLAIMER

The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
// Sample Code

package main

// Import the packages
import (
	"context"
	"log"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
	"github.com/Azure/go-autorest/autorest/to"
)

// Define key global variables.
var (
	subscriptionId    = "XXXXXXXXXXXXXXX" // !! IMPORTANT: Change this to your subscription.
	location          = "YourRGLocation"  // !! IMPORTANT: Change this to your RG Location in your subscription.
	resourceGroupName = "YourRGName" // !! IMPORTANT: Change this to a unique name in your subscription.
	ctx               = context.Background()
)


// Update the resource group by adding a tag to it.
func updateResourceGroup(subscriptionId string, credential azcore.TokenCredential) (armresources.ResourceGroupsClientUpdateResponse, error) {
	rgClient, err5 := armresources.NewResourceGroupsClient(subscriptionId, credential, nil)

	if err5 != nil {
		log.Fatal(err5)
	}
	update := armresources.ResourceGroupPatchable{
		Tags: map[string]*string{
			"new": to.StringPtr("tag"),
		},
	}
	return rgClient.Update(ctx, resourceGroupName, update, nil)
}

// main function
func main() {

	// Create a credentials object.
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		log.Fatalf("Authentication failure: %+v", err)
	}

	// Call your function to add a tag to your new resource group.
	updatedRG, err := updateResourceGroup(subscriptionId, cred)
	if err != nil {
		log.Fatalf("Update of resource group failed: %+v", err)
	}
	log.Printf("Resource Group %s updated", *updatedRG.ResourceGroup.ID)

}
```
