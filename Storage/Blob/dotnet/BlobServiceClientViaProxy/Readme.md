---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to perform the Blob Storage Get Service properties via the Proxy 

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Blobs .NET Library to perform the Blob Storage Get Service properties via the Proxy.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 You need to ensure that the proxy has whitelisted the storage endpoints, https://management.azure.com, https://login.microsoftonline.com endpoints and whitelisted the port 443.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using System;
using System.IO;
using System.Threading.Tasks;
using Azure.Storage.Blobs.Specialized;
using System.Data.Common;
using Azure.Core.Pipeline;
using Azure.Storage;
using System.Net;
using Azure.Identity;

namespace BlobServiceClientviaProxy
{
    class Program
    {
        static async Task Main()
        {
            string proxyAddress = "http://MyProxy.abc.com:8888";

            string connectionString = "XXXXXXXXXXStorageAccountConnectionStringXXXXXXX";

            // Create a BlobServiceClient object which will be used to create a container client

            var endpoint = new Uri("https://MyStorageAccount.blob.core.windows.net/");

            // If you would like to use the StorageSharedKeyCredential to perform the storage operations
            StorageSharedKeyCredential credential = new StorageSharedKeyCredential("MyStorageAccount", "XXXXXXMyStorageAccountAccessKeyXXXXXXXX");

            // If you would like to use the DefaultAzureCredential to perform the storage operations then you can uncomment the below line. 
            // var credential = new DefaultAzureCredential();
                        
            var blobServiceClient = new BlobServiceClient(endpoint, credential, new BlobClientOptions()
            {
                Transport = new HttpClientTransport(new HttpClient(new HttpClientHandler
                {
                    Proxy = new WebProxy(proxyAddress),
                    UseProxy = true,
                    UseDefaultCredentials = true
                }))
            });
            
            // Display the storage account service properties.
            var properties = blobServiceClient.GetProperties(); 
            Console.WriteLine(properties);

            Console.ReadLine();
        }
    }
}


```
