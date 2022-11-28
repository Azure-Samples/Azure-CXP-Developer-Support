---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to call SyncCopyFromUriAsync() method to perform the copy blob operation with same storage account.

 Code Overview and Pre-requisites
 
 This sample code uses the SyncCopyFromUriAsync() method to perform the copy operation with the same storage account.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a source blob within this container. This source blob is what we will be using to perform copy operation with the same container as destination blob. 
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
            StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential("MyStorageAccountName", "StorageAccountAccessKey");

            Uri accountUri = new Uri("https://MyStorageAccountName.blob.core.windows.net/");
            BlobServiceClient client = new BlobServiceClient(accountUri, sharedKeyCredential);
            BlobContainerClient containerClient = client.GetBlobContainerClient("test");
            
            BlobClient sourceClient = containerClient.GetBlobClient("source.txt");
            BlobClient destinationClient = containerClient.GetBlobClient("destination.txt");

            try
            {
                /*----------Perform the SyncCopyFromUriAsync operation ------*/
                Console.WriteLine("performing SyncCopyFromUriAsync ");
                await destinationClient.SyncCopyFromUriAsync(sourceClient.GenerateSasUri(BlobSasPermissions.Read, DateTimeOffset.UtcNow.AddMinutes(10)));
               
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
