---
page_type: sample
languages:
- csharp
products:
- azure-iot
---


# csharp sample code to perform the Query operation on the Azure Digital Twins using LastUpdatedOn property.

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.DigitalTwins.Core .NET Library to perform the Query operation on Azure Digital Twin using LastUpdatedOn property in the WHERE statement.
 Before running this, you need to have an Azure Digital Twins instance within your Azure Subscription.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using System;
using System.Linq;
using Microsoft.Azure.DigitalTwins;
using System.Text.Json;


async Task GetAndSortDigitalTwinsAsync()
{
    // Create instance of DigitalTwinsClient
    var client = new DigitalTwinsClient(new Uri("https://<your-dt-instance>.<region>.azuresmartspaces.net"), new AzureADCredential("<tenant-id>", "<client-id>", "<client-secret>"));
    var digitalTwins = await client.GetDigitalTwinsAsync();
    var time = DateTime.UtcNow.AddYears(-2);
    
    // We will query the $metadata.$lastUpdateTime field. Make sure to use an ISO8601 formatted string (DateTime.ToString(“o”))
    var query = $"SELECT * FROM DIGITALTWINS WHERE $metadata.$lastUpdateTime > '{time.ToString("o")}'";
    
    Console.WriteLine(query);
    
    // Query the digital twin
    var q = digitalTwins.QueryAsync<JsonElement>(query);
    await foreach(var item in q)
    {
        Console.WriteLine(item);
    }
}

```
