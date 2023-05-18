---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code that uses the ShareDeleteOptions.Conditions Property to delete the share which Lease ID in the Azure Storage Account.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Storage.Files.Shares .NET Library to use the [ShareDeleteOptions.Conditions](https://learn.microsoft.com/en-us/dotnet/api/azure.storage.files.shares.models.sharedeleteoptions.conditions?view=azure-dotnet) Property to perform the File share delete that has an active lease.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a File share within your storage account. The below sample acquires the lease on the share and then we can use the [ShareFileRequestConditions.LeaseId](https://learn.microsoft.com/en-us/dotnet/api/azure.storage.files.shares.models.sharefilerequestconditions.leaseid?view=azure-dotnet#azure-storage-files-shares-models-sharefilerequestconditions-leaseid) Property to specify the lease and then delte the share. 
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Storage.Files.Shares;
using Azure.Storage.Files.Shares.Models;
using Azure.Storage.Files.Shares.Specialized;

namespace ShareDeleteOptions
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // Connection string to the Azure Storage account
            string connectionString = "XXXXXXXXXXXXXXXXXXXXXX";

            // Name of the share to be deleted
            string shareName = "myShareName";

            // Set the desired lease duration
            TimeSpan leaseDuration = TimeSpan.FromSeconds(60); 

            // Create an instance of ShareServiceClient using the connection string
            ShareServiceClient shareServiceClient = new ShareServiceClient(connectionString);

            // Get a reference to the share you want to delete
            ShareClient shareClient = shareServiceClient.GetShareClient(shareName);

            // Acquire the lease
            ShareLeaseClient leaseClient = shareClient.GetShareLeaseClient();
            var lease = leaseClient.Acquire(leaseDuration);

            // Print the lease ID of the acquired lease
            Console.WriteLine("Lease acquired successfully. Lease ID: " + lease.Value.LeaseId);


            // Create an instance of ShareDeleteOptions and set the conditions
            Azure.Storage.Files.Shares.Models.ShareDeleteOptions options = new Azure.Storage.Files.Shares.Models.ShareDeleteOptions
            {
                Conditions = new ShareFileRequestConditions
                {
                    
                    LeaseId = lease.Value.LeaseId.ToString()
                }
            };

            // Delete the share with the specified conditions
            shareClient.Delete(options);
        }
    }
}
```
