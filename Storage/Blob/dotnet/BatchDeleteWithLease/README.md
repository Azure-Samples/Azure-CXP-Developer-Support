---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to perform the BatchDelete operation on the blobs with lease in the Azure Storage Account.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Blobs .NET Library to perform the BatchDelete operation on Azure Storage blobs which has lease.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a blob within this container. Acquire the lease on the Blob and copy the leaseId for use within the application. 
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
using Azure.Storage.Blobs.Batch;
using Azure.Storage.Blobs;
using Azure.Storage;
using Azure.Storage.Blobs.Specialized;
using Azure.Storage.Blobs.Models;

namespace BatchDeleteAsync
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Update the Storage Account Name and the Access key
            StorageSharedKeyCredential sharedKeyCredential = new StorageSharedKeyCredential("MyStorageAccount", "AccessKey");

            Uri accountUri = new Uri("https://MyStorageAccount.blob.core.windows.net/");
            BlobServiceClient client = new BlobServiceClient(accountUri, sharedKeyCredential);
            BlobContainerClient container = client.GetBlobContainerClient("MyContainerName");
            BlobClient foo = container.GetBlobClient("MyBlobName");
             
            // Create an instance of the BlobBatchClient 
            BlobBatchClient batchClient = client.GetBlobBatchClient();

            BlobBatch blobBatch = batchClient.CreateBatch();

            try
            {
                // Perform the Blob BatchDelete Operation
                blobBatch.DeleteBlob(foo.Uri, conditions: new BlobRequestConditions()
                {
                    // Specify the leaseID which you had copied after acquiring the lease on the blob
                    LeaseId = "6860da6e-8757-4b83-b42b-68ba9fccba72"
                });
                await batchClient.SubmitBatchAsync(blobBatch, throwOnAnyFailure: true);

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
