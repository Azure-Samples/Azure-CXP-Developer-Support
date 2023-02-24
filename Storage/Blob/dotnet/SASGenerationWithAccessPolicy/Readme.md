---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to generate the SAS token from Stored Access Policy in the Azure Blob Storage Account.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Blobs .NET Library to perform the Generate SAS Uri operation from the stored access policy on Azure Storage.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a blob within this container.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using System;
using System.Collections.Generic;
using System.IO;
using Azure.Storage.Blobs;
using Azure.Storage;
using Azure.Storage.Blobs.Specialized;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;
using Azure;

namespace SASSharedAccessPolicy
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Update the Storage account name and Storage Access key in the below code
            StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential("StorageAccountName", "StorageAccessKey");

            Uri accountUri = new Uri("https://StorageAccountName.blob.core.windows.net/");
            
            BlobServiceClient client = new BlobServiceClient(accountUri, sharedKeyCredential);
            try { 
                    BlobContainerClient containerClient = client.GetBlobContainerClient("test");

                    BlobClient blobClient = containerClient.GetBlobClient("source.txt");

                    // Create one or more stored access policies.
                    List<BlobSignedIdentifier> signedIdentifiers = new List<BlobSignedIdentifier>
                    {
                        new BlobSignedIdentifier
                        {
                            Id = "mysignedidentifier",
                            AccessPolicy = new BlobAccessPolicy
                            {
                                StartsOn = DateTimeOffset.UtcNow.AddHours(-1),
                                ExpiresOn = DateTimeOffset.UtcNow.AddDays(1),
                                Permissions = "rwdl"
                            }
                        }
                    };
                    
                    // Set the container's access policy.
                    await containerClient.SetAccessPolicyAsync(permissions: signedIdentifiers);

                    // Create the SASBuilder instance using the Storead Access Policy
                    BlobSasBuilder sasBuilder = new BlobSasBuilder()
                    {
                        Identifier = "mysignedidentifier",
                        BlobContainerName = blobClient.GetParentBlobContainerClient().Name,
                        BlobName = blobClient.Name,
                        Resource = "b",

                    };
                
                // Generate the SAS Uri
                Uri sasUri = blobClient.GenerateSasUri(sasBuilder);

                Console.WriteLine("SAS URI for blob is: {0}", sasUri);
                Console.WriteLine();
                Console.ReadLine();
            }
            catch (RequestFailedException e)
            {
                Console.WriteLine(e.ErrorCode);
                Console.WriteLine(e.Message);
            }
        }
    }
}
```
