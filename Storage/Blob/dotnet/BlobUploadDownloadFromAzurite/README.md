---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to Upload and Download the blobs to/from Containarized Azurite 

 Code Overview and Pre-requisites
 
 This sample code uses the Azurite on docker to upload the blob and down the blobs from it using the Azure.Storage.Blobs library
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Ensure that you have the docker installed on your locker machine. Then run the command:  `docker run --rm -p 10000:10000 mcr.microsoft.com/azure-storage/azurite azurite-blob --blobHost 0.0.0.0`
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Blobs.Specialized;


namespace StorageAzurite
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Container Name 
            var blobContainerName = Guid.NewGuid().ToString("D");
             
            // Update the Azurite connectionString 
            const string connectionString = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=XXXXXXXXXXXXXXXXXXXXXXXX;BlobEndpoint=http://localhost:10000/devstoreaccount1;";

            var blobServiceClient = new BlobServiceClient(connectionString);

            // Create an instance of BlobContainerClient
            BlobContainerClient blobContainerClient = await blobServiceClient.CreateBlobContainerAsync(blobContainerName);

            var client = new BlobContainerClient(connectionString, blobContainerName);

            var blobClient = new BlobClient(new Uri(blobContainerClient.Uri.ToString() + "/data"),
                                new StorageSharedKeyCredential("devstoreaccount1", "XXXXXXXXXXXXXXXXXXXXXXXXXX"));

            // Upload the Blob with a sample content
            _ = await blobClient.UploadAsync(new MemoryStream(new byte[] { 0 }), true);

            // Download the Blob which we have just uploaded
            BlobDownloadInfo download = await blobClient.DownloadAsync();

        }
    }
}

```
