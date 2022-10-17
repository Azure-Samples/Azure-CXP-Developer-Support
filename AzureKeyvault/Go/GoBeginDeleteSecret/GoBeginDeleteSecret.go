// DISCLAIMER
// The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

// Code Overview and Pre-requisites
// This sample code uses the azsecrets go SDK package to perform BeginDeleteSecret to delete a secret from your Azure Keyvault.
// Before running this, you need to create an Azure Keyvault with a secret with soft delete feature enabled within your Azure Subscription.
// Use go version go1.18.1 windows/amd64
// Package to be imported are listed in the sample code below.
// Update all the variable details in the below code before running the sample.


//Sample Code

package main

import (
        "context"
        "fmt"
        "log"
        "time"
        "errors"

        "github.com/Azure/azure-sdk-for-go/sdk/azcore"
        "github.com/Azure/azure-sdk-for-go/sdk/azidentity"
        "github.com/Azure/azure-sdk-for-go/sdk/keyvault/azsecrets"
)

func main() {

        mySecretName := "MySampleKVSecret"
        mySecretValue := "MySecretValue"
	      keyVaultName := "MyKVName"
        keyVaultUrl := fmt.Sprintf("https://%s.vault.azure.net/", keyVaultName)

        //Create a credential using the NewDefaultAzureCredential type.
        cred, err := azidentity.NewDefaultAzureCredential(nil)
        if err != nil {
                log.Fatalf("failed to obtain a credential: %v", err)
        }

        //Establish a connection to the Key Vault client
        client, err := azsecrets.NewClient(keyVaultUrl, cred, nil)
        if err != nil {
                log.Fatalf("failed to connect to client: %v", err)
        }

        //Create a secret
        _, err = client.SetSecret(context.TODO(), mySecretName, mySecretValue, nil)
        if err != nil {
                log.Fatalf("failed to create a secret: %v", err)
}

        //Delete a secret
        respDel, err := client.BeginDeleteSecret(context.TODO(), mySecretName, nil)
        if err != nil {
                var respErr *azcore.ResponseError
                if !errors.As(err, &respErr) || respErr.StatusCode != 400 {
                        // TODO: unexpected error; do something
                        log.Fatalf("unexpected error: %v", err)
                }
                // nothing to do, got the expected error
        }

         // If you do not care when the secret is deleted, you do not have to
        // call resp.PollUntilDone. If you need to know when it's done use
        // the PollUntilDone method.

        _, err = respDel.PollUntilDone(context.TODO(), time.Second)
        if err != nil {
                log.Fatalf("failed to delete secret: %v", err)
        }

        fmt.Println(mySecretName + " has been deleted\n")
}
