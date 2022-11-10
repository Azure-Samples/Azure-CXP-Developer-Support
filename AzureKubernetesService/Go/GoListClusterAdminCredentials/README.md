---
page_type: sample
languages:
- Go
products:
- azure-kubernetes-service
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
//Sample Code

package main

import (
	"context"
	"log"
	"github.com/Azure/azure-sdk-for-go/services/containerservice/mgmt/2022-01-01/containerservice"
	"github.com/Azure/go-autorest/autorest/azure/auth"
)

var (
	subscriptionID      string
	objectID            string
	clientSecret        string
	clientID            string
	TenantID            string
	location            = "MyLocation"
	resourceGroupName   = "MyRG"
	managedClustersName = "MyClusterName"
	configName          = "MyConfigName"
)

func main() {
	subscriptionID = os.Getenv("AZURE_SUBSCRIPTION_ID")
	if len(subscriptionID) == 0 {
		log.Fatal("AZURE_SUBSCRIPTION_ID is not set.")
	}

	objectID = os.Getenv("AZURE_OBJECT_ID")
	if len(objectID) == 0 {
		log.Fatal("AZURE_OBJECT_ID is not set.")
	}

	clientSecret = os.Getenv("AZURE_CLIENT_SECRET")
	if len(clientSecret) == 0 {
		log.Fatal("AZURE_CLIENT_SECRET is not set.")
	}

	clientID = "7f68d8ff-XXXXX-XXXX-XXXX-XXXXXX309ed"
	if len(clientID) == 0 {
		log.Fatal("AZURE_CLIENT_ID is not set.")
	}

	TenantID = "72XXXX-XXXXX-XXXX-XXXX-XXXXXdb47"
	if len(clientSecret) == 0 {
		log.Fatal("AZURE_TENANT_ID is not set.")
	}
	ctx := context.Background()

	credConfig := auth.NewClientCredentialsConfig(clientID, clientSecret, TenantID)
	authorizer, err := credConfig.Authorizer()
	if err != nil {
		//return nil, err
	}

	aksClient := containerservice.NewManagedClustersClient(subscriptionID)
	aksClient.Authorizer = authorizer
	// List admin credentials
	res, err := aksClient.ListClusterAdminCredentials(ctx, resourceGroupName, managedClustersName, "")
	if err != nil {
		//return nil, err
	}
	log.Println("Azure data", "Kubeconfigs", res.Kubeconfigs) 

}
```
