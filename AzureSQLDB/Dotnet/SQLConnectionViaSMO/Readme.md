---
page_type: sample
languages:
- csharp
products:
- azure-sql-database
---


# csharp sample code to connect to Azure SQL Server using SQL Server Management Object

 Code Overview and Pre-requisites
 
 This sample code uses the Microsoft.SqlServer.Management.Smo .NET Library to connect to Azure SQL DB.
 Before running this, you need to create an Azure SQL Database resource within your Azure Subscription.
 After creation, ensure that the SQl Server resource has the Public Network access enabled as mentioned [here](https://learn.microsoft.com/en-us/azure/azure-sql/database/connectivity-settings?view=azuresql&tabs=azure-portal#deny-public-network-access).
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
//Sample Code
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;

namespace SQLConnectionConsole
{
    internal class Program
    {
        static async Task Main(string[] args)
        {
            // Update the below variables before running the code
            string serverName = "MySQLServer.database.windows.net";
            string dbName = "MySQLDBName";
            string username = "MyUserName";
            string password = "MyPassWord";

            // Frame the SQL connection string
            string connectionString = $"Server={serverName};Database={dbName};User Id={username};Password={password};";

            try
            {
                // Create a SQL Server Connection
                ServerConnection serverConnection = new ServerConnection();
                serverConnection.ConnectionString = connectionString;
                Server server = new Server(serverConnection);

                // Code to connect to the SQL Server
                server.ConnectionContext.Connect();
                Console.WriteLine($"Connected to server: {serverName}, database: {dbName}");

                Console.WriteLine($"{Environment.NewLine}Server: {server.Name}");
                Console.WriteLine($"Edition: {server.Information.Edition}{Environment.NewLine}");

                //Disconnect from Azure SQL Server
                server.ConnectionContext.Disconnect();
                Console.WriteLine($"Disconnected from server: {serverName}, database: {dbName}");
            }
            catch (Exception err)
            {
                //catch the exception and display it
                Console.WriteLine(err.Message);
                throw;
            }
            Console.ReadLine();
        }
    }
}

```
