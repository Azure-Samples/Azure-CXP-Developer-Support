---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to Query and List all the Tables win the Azure Storage Account.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Data.Tables .NET Library to perform the Query operation to List the Tables in your Azure STorage Account.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a few Tables within this Storage Account. 
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Azure.Data.Tables;
using Azure.Data.Tables.Models;
using Azure;

namespace StorageGetTables
{
    internal class Program
    {
        static async Task Main(string[] args)
        {

             var storageUri = "https://StorageAccountName.table.core.windows.net/";
             
            // Construct a new "TableServiceClient using a TableSharedKeyCredential.
            var serviceClient = new TableServiceClient(
            new Uri(storageUri),
            new TableSharedKeyCredential("StorageAccountName", "StorageAccessKey"));

            // If you would like to filter for a particular Storage Table name
            // Pageable<TableItem> queryTableResults = serviceClient.Query(filter: $"TableName eq '{tableName}'");
 
            // Query all the tables in Azure Storage
            Pageable<TableItem> queryTableResults = serviceClient.Query();

            Console.WriteLine("The following are the names of the tables in the query results:");

            foreach (TableItem table in queryTableResults)
            {
                Console.WriteLine(table.Name);
            }
            
            Console.ReadLine();
        }
    }
}



```
