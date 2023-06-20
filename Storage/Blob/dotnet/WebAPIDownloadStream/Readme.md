---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp web api sample code to download the blob content as a stream. 

 Code Overview and Pre-requisites
 
 This web api sample code helps in invoking a GET call to download the blob as a stream.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account with Private access level. Upload a blob within this container. Copy the Connection string of the STorage ACcount and update that in the below code. 
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

```
using Azure.Storage.Blobs;
using System.IO;
using System.Web.Mvc;
using System.Web;
using System.Threading.Tasks;
using Azure.Storage.Blobs.Models;
using System.Web.Http;
using System.Net.Http;
using System.Net;

namespace StorageFileStream.Controllers
{
    public class HomeController : ApiController
    {

        private readonly string _connectionString = "XXXXXXXXX";
        private readonly string _containerName = "MyContainerName";
        private readonly string _blobName = "MyBlobName";

       
        [System.Web.Http.HttpGet]
        public async Task<HttpResponseMessage> DownloadFile()
        {
            BlobServiceClient blobServiceClient = new BlobServiceClient(_connectionString);
            BlobContainerClient containerClient = blobServiceClient.GetBlobContainerClient(_containerName);
            BlobClient blobClient = containerClient.GetBlobClient(_blobName);

           // Download the blob content
            BlobDownloadInfo download = await blobClient.DownloadAsync();
            Stream stream = download.Content;

           // Create an HttpResponseMessage
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            response.Content = new StreamContent(stream);
           // Set the content type of the response to the blob's content type
            response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(download.ContentType);
            response.Content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment")
            {
                FileName = _blobName
            };

            // Set the content length header
            if (stream.CanSeek)
            {
                response.Content.Headers.ContentLength = stream.Length;
            }

            return response;
        }
    }
}
```
