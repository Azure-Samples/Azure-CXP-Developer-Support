---
page_type: sample
languages:
- csharp
products:
- azure-cost-management
---


# csharp sample code to fetch the usage details by directly invoking the Consumption usage API at the subscription scope.

 Code Overview and Pre-requisites
 
 This sample code invokes the Consumption API to get the Usage Details. You could achieve the same by using the `Azure.ResourceManager.Consumption` .Net Library.
 Before running this, you need to create a service principal in your AAD tenant and ensure that it has enough permissions to fetch the Usage.
 Also you need to update the scope depending on your requirement. The below sample fetches at the subscription scope.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code

using Azure.Core;
using Azure.Identity;
using Azure.ResourceManager.Consumption;
using Azure.ResourceManager.Consumption.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;


namespace AzureCostReport
{
    class Program
    {
        // Update the below constants with your Azure subscription ID, tenant ID, client ID, and client secret.
        
        private const string subscriptionId = "XXXXXXXX";
        private const string tenantId = "XXXXXXX";
        private const string clientId = "XXXXXXXXXXXXXXXXX";
        private const string clientSecret = "XXXXXXXXXXXXXXXXXXXXXX";
        

        static async Task Main(string[] args)
        {
            // Authenticate using a service principal.
            var credential = new ClientSecretCredential(tenantId, clientId, clientSecret);

            // Get the bearer token
            var token = await credential.GetTokenAsync(new TokenRequestContext(new[] { "https://management.azure.com/.default" }));

            // Get the Cost details
            GetCostDetails(token).Wait();
            Console.ReadLine();

        }
        private static async Task GetCostDetails(AccessToken token)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token.Token);

            //Invoke te Consumption details REST API
            var result = await client.GetAsync("https://management.azure.com/subscriptions/b83c1ed3-XXXX-XXXX--2b83a074c23f/providers/Microsoft.Consumption/usageDetails?startDate=2020-08-01&endDate=2020-08-05&$top=1000&api-version=2019-10-01");

            Console.WriteLine(await result.Content.ReadAsStringAsync());
            
        }
    }
}

```
