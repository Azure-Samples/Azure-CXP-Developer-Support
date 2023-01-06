---
page_type: sample
languages:
- csharp
products:
- azure-app-configuration	
---


# csharp sample code to get the keys from Azure App Configuration

 Code Overview and Pre-requisites
 
 This sample code uses the Azure.Data.AppConfiguration library to get the key value from Azure App Configuration.
 Before running this, you need to create anAzure App Configuration within your Azure Subscription.
 Create a Key Value pair with your Azure App Configuration resource.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using System;
using System.Threading.Tasks;
using Azure.Data.AppConfiguration;

namespace ConsoleApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
            // The key string which you are trying to fetch from the App Configuration
            string key = "Test";
            
            // Replace the connection string with your App Configuration connection string.
            string connectionString = "XXXXXXXXXXXXX";

            // Create a ConfigurationClient instance.
            var client = new ConfigurationClient(connectionString);

            // Get the list of keys.
            ConfigurationSetting keys = client.GetConfigurationSetting(key);

            Console.WriteLine(keys);
            Console.ReadLine();

        }
    }
}


```
