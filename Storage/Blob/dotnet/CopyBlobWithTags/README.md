---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to call SyncCopyFromUriAsync() method to copy blob with Blob tags from source to destination blob within the storage Account

 Code Overview and Pre-requisites
 
 This sample code uses the SyncCopyFromUriAsync() method to perform the copy blob operation with Blob tags from source blob to destination blob within the same storage Account
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
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
using Azure.Storage.Sas;

namespace StartAndSyncCopyFromUriAsync
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Update the Storage Account Name and Access Key
            StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential("MyStorageAccountName", "XXXXXXXXXXXXXXXXXX");

            Uri accountUri = new Uri("https://MyStorageAccountName.blob.core.windows.net/");
            BlobServiceClient client = new BlobServiceClient(accountUri, sharedKeyCredential);
            BlobContainerClient containerClient = client.GetBlobContainerClient("MyContainer");
         
            BlobClient destinationClient = containerClient.GetBlobClient("destination.txt");
            
            // Firstly create the source blob to be uploaded with the Blob Tags

            BlobClient sourceClient = containerClient.GetBlobClient("source.txt");

            // Sample content for the source blob

            MemoryStream memoryStream = new MemoryStream(new byte[] { 1, 2, 3 });
            
            BlobUploadOptions blobUploadOptions = new BlobUploadOptions
            {
                Tags = new Dictionary<string, string> { { "tagname", "tagvalue" } }
            };

            // Upload a source blob with the Blob Tags
            await blobClient1.UploadAsync(memoryStream, blobUploadOptions);

            BlobCopyFromUriOptions options = new BlobCopyFromUriOptions
            {
                CopySourceTagsMode = BlobCopySourceTagsMode.Copy,
            };

            try
            {
                // Method to perform the source blob copy operation which will also copy the blob tags to the destination blob
                await destinationClient.SyncCopyFromUriAsync(sourceClient.GenerateSasUri(BlobSasPermissions.All, DateTimeOffset.UtcNow.AddMinutes(10)), options);

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
