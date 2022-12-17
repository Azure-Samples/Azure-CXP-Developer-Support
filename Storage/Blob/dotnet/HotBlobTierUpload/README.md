---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to perform the Blob Upload to Hot Access Tier with Azure Storage

 Code Overview and Pre-requisites
 
 This sample code performs the Blob Upload operation to Hot Access Tier within the storage Account
 Before running this, you need to create a Standard GPv2 Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a source blob within this container with relevant Blob tags. This source blob is what we will be using to perform copy operation within the same container as destination blob. 
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```

//Sample Code

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Azure.Storage;
using Azure.Storage.Blobs.Specialized;
using Azure.Storage.Blobs.Models;

namespace HotBlobTierUpload
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
                       string connectionString = "Storage Account - Connection String";

            // Create a BlobServiceClient object which will be used to create a container client
            BlobServiceClient blobServiceClient = new BlobServiceClient(connectionString);

            //Create a unique name for the container
            string containerName = "MyContainerName" + Guid.NewGuid().ToString();

            // Create the container and return a container client object
            BlobContainerClient containerClient = await blobServiceClient.CreateBlobContainerAsync(containerName);


            // Create a local file in the ./data/ directory for uploading and downloading
            string localPath = "./data/";
            string fileName = "MyBlob.txt";
            string localFilePath = Path.Combine(localPath, fileName);

            // Write text to the file
            await File.WriteAllTextAsync(localFilePath, "HelloWorld");

            // Get a reference to a blob
            BlobClient blobClient = containerClient.GetBlobClient(fileName);

            var uploadOptions = new BlobUploadOptions
            {
                AccessTier = AccessTier.Hot
            };

            try
            {
                // function to perform the blob upload operation
                  await blobClient.UploadAsync(localFilePath, options: uploadOptions);

            }
            catch (AggregateException)
            {
                // An aggregate exception is thrown for all the individual failures
                // Check ex.InnerExceptions for RequestFailedException instances
            }
        }
    }
}

```
