---
page_type: sample
languages:
- Go
products:
- virtual-machines	
---


# Go sample code uses armcompute go SDK package to get instance view of Azure Virtual Machine.


 Code Overview and Pre-requisites
 
 This sample code uses the armcompute SDK for Go package to get the instance view of the Azure Virtual Machine. This retrieves information about the run-time state of a virtual machine.
 Before running this, you need to create an Azure Virtual Machine in your Azure Subscription.
 Set the environment variables AZURE_SUBSCRIPTION_ID, AZURE_TENANT_ID, AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_OBJECT_ID
 Use go version go1.18.1 windows/amd64
 Package to be imported are listed in the sample code below.
 Update all the variable details in the below code before running the sample.


DISCLAIMER

The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

```
// Sample Code
package main

import (
	"context"
	"fmt"
	"log"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/compute/armcompute"
)

var (
	subscriptionID    = "XXXX-XXXX-XXX-XXXX"
	resourceGroupName = "MY-RESOURCES"
	vmName            = "MySampleVMName"
)

func main() {

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		log.Fatal(err)
	}
	ctx := context.Background()

	// Creating Azure Virtual Machine client
	client, err := armcompute.NewVirtualMachinesClient(subscriptionID, cred, nil)

	// Get the instance view of the Azure VM

	instanceView, err := client.InstanceView(ctx, resourceGroupName, vmName, nil)
	if err != nil {
		fmt.Println(err)
		return
	}

	// Print the instance view
	fmt.Println(instanceView)

}

```
