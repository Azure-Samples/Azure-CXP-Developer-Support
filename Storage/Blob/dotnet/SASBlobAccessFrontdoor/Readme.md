---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to call SyncCopyFromUriAsync() method to copy blob with Blob tags from source to destination blob within the storage Account

 Code Overview and Pre-requisites
 
 This sample code uses the BlobServiceClient() method with SASToken parameter and uses the Azure Frontend URL to access the Blob Storage
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Ensure that you have created a Azure FrontDoor Resource and have add the Storage endpoint as the origin in the Front door resource.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using Azure;
using Azure.Storage;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

namespace StorageGetBlobs
{
    internal class Program
    {
        static async Task Main(string[] args)
        {

            try
            {
                // Update your Azure FrontDoor url
                var serviceUri = "https://AzureFrontDoor.z01.azurefd.net/";

                // You can generate a service SAS or account SAS from application. The below SAS token is generated from Azure Portal
                var sasToken = "?sv=2021-12-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-03-30T15:25:29Z&st=2023-03-16T07:25:29Z&spr=https&sig=XXXXXXXXXXXXXXX";

                // Update the Container Name
                string containerName = "test";

                // Construct a new BlobServiceClient using a AzureSasCredential.
                BlobServiceClient blobServiceClient = new BlobServiceClient(new Uri(serviceUri), new AzureSasCredential(sasToken));
                BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);

                Console.WriteLine("The following are the names of the blobs in the Azure Storage Container:");

                await foreach (BlobItem blobItem in containerClient.GetBlobsAsync()) 
                {
                    Console.WriteLine(blobItem.Name);
                }
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
            }
            Console.ReadLine();
        }
    }
}

```
