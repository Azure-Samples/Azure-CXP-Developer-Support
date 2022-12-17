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

