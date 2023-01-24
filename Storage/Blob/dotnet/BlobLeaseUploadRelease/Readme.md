---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# C# sample code to upload and release a blob with lease

 ## Code Overview 
 
 This sample code uses the `v12 .NET SDK Azure.Storage.Blobs` library to perform the blob upload with lease and then release the lease on the blob within the Azure Storage Account.
 
 ## Pre-requisites
 Before running this, you need to:
 - Create an Azure Storage Account within your Azure Subscription.
 - Create a Container within your Storage Account with private access level. 
 - Upload a source blob within this container.
 - Update all the variable details in the below code before running the sample.
 
 
## DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided **AS IS** without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages. 


```
//Sample Code

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;
using Azure;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Blobs.Specialized;

namespace BlobSample
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Replace these values with your own storage account information.
            string storageAccountName = "MyStorageAccountName";
            string storageAccountKey = "MyStorageAccountKey";

            // Create a blob service client.
            BlobServiceClient serviceClient = new BlobServiceClient(
                $"DefaultEndpointsProtocol=https;AccountName={storageAccountName};AccountKey={storageAccountKey}");

            // Get a reference to the container that contains the blob you want to release the lock on.
            BlobContainerClient container = serviceClient.GetBlobContainerClient("MyContainerName");

            // Get a reference to a blob
            BlobClient blobClient = container.GetBlobClient("MyBlobName");

            BlobLeaseClient blobLeaseClient = blobClient.GetBlobLeaseClient();

            BlobLease blobLease = await blobLeaseClient.AcquireAsync(TimeSpan.FromSeconds(60));

            // Set the request condition to include the lease ID.
            BlobUploadOptions blobUploadOptions = new BlobUploadOptions()
            {
                Conditions = new BlobRequestConditions()
                {
                    LeaseId = blobLease.LeaseId
                }
            };

            MemoryStream stream = new MemoryStream(Encoding.ASCII.GetBytes("Hello World"));
            await blobClient.UploadAsync(stream, blobUploadOptions);
            Console.WriteLine("Uploading to Blob storage as blob:\t {0} with Lease ID: {1} \n ", blobClient.Uri, blobLease.LeaseId);
            Console.WriteLine("Click Enter to Release the lease");
            Console.ReadLine();
            try
            { 
                // Release the lease on the blob
                await blobLeaseClient.ReleaseAsync();

                Console.WriteLine("Succesfully Released the Lease from the blob", blobClient.Uri);
            }
            catch (RequestFailedException ex)
            {
                Console.WriteLine(ex.Message);   
            }
            Console.ReadLine();
        }
    }
}



```
