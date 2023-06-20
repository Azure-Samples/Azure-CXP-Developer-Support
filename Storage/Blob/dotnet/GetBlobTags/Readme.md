---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to get the blob tags for the blobs in the Azure Storage Account.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Blobs .NET Library tofetch the blob tags.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a blob within this container. Add a few tags to that blob. 
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;

// Create a BlobServiceClient object
BlobServiceClient blobServiceClient = new BlobServiceClient(connectionString);

// Get a reference to a blob container
BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(containerName);

// Get a reference to a blob
BlobClient blobClient = containerClient.GetBlobClient(blobName);

// Get all tags of the blob
BlobTags tags = await blobClient.GetTagsAsync();


```
