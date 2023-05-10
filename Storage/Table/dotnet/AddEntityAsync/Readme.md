---
page_type: sample
languages:
- csharp
products:
- azure-storage	
---


# csharp sample code to asynchronously add the entities in the Azure Table Storage.

 Code Overview and Pre-requisites
 
 This sample code uses the `Azure.Data.Tables` .NET Library to perform the **AddEntityAsync()** operation to insert entities into the Azure Table Storage.
 Before running this, you need to ensure that you have a Table created within your Azure Storage account within your Azure Subscription. Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using Azure;
using Azure.Data.Tables;
using System;

class Program
{
    static async Task Main(string[] args)
    {
        string connectionString = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        string tableName = "TableName";

        // Create a new TableClient using the connection string and table name
        TableClient tableClient = new TableClient(connectionString, tableName);

        // Create a sample entity
        var sampleEntity = new SampleEntity("PartitionKey", "RowKey")
        {
            Property1 = "Value 1",
            Property2 = 100,
            Property3 = DateTime.UtcNow
        };

        try
        {
            // Add the entity to the table
            await tableClient.AddEntityAsync(sampleEntity);
            Console.WriteLine("Entity added successfully.");
        }
        catch (RequestFailedException ex)
        {
            Console.WriteLine($"Error adding entity: {ex.Message}");
        }
    }
}

// Define a sample entity class with properties
public class SampleEntity : ITableEntity
{
    public SampleEntity(string partitionKey, string rowKey)
    {
        PartitionKey = partitionKey;
        RowKey = rowKey;
    }

    public SampleEntity() { }

    public string PartitionKey { get; set; }
    public string RowKey { get; set; }
    public string Property1 { get; set; }
    public int Property2 { get; set; }
    public DateTime Property3 { get; set; }

    public DateTimeOffset? Timestamp { get; set; }
    public ETag ETag { get; set; }
}

```
