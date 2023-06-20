---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to perform a stream upload file to Azure file storage.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Files.Shares .NET Library to upload file stream and create a file in Azure file storage. 
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a File share within your storage account. Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

```
// Import the necessary namespaces for working with Azure File Storage
using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;
using System.IO;

// Specify the connection string for your Azure File Storage account
string connectionString = "your_connection_string";

// Specify the name of the file share where you want to upload the file
string shareName = "your_share_name";

// Specify the desired name for the file you want to upload
string fileName = "your_file_name";

// Replace this with your actual data retrieval logic or provide your own dummy data
string dummyText = "This is a sample file content.";
byte[] dummyData = Encoding.UTF8.GetBytes(dummyText);

// Replace this with your actual stream retrieval logic
// For demonstration purposes, we'll create a MemoryStream with dummy data
MemoryStream stream = new MemoryStream(dummyData);


// Get the stream that contains the data you want to upload
// Stream stream = GetYourFileStream(); // Replace with your own stream if you don't want to use the above code.

// Create a client to interact with the file in the Azure File Storage
ShareFileClient fileClient = new ShareFileClient(connectionString, shareName, fileName);

// Specify the upload options, including transfer options
ShareFileUploadOptions uploadOptions = new ShareFileUploadOptions
{
    TransferOptions = new StorageTransferOptions
    {
        // Specify the initial and maximum transfer size for the upload
        InitialTransferSize = 1024 * 1024 * 4,
        MaximumTransferSize = 1024 * 1024 * 4
    }
};

// Create the file on the Azure File Storage with the specified size
await fileClient.CreateAsync(stream.Length);

// Upload the stream to the file in the Azure File Storage, using the specified upload options
await fileClient.UploadAsync(stream, uploadOptions);


```
