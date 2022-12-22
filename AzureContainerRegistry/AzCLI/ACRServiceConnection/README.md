---
page_type: sample
languages:
- azurecli
products:
- azure-container-registry
---

# AzureCLI command is to configure linked services in acr account using json format configuration file

Script Overview and Pre-requisites

This sample shell script is to configure linked services in acr account using json format configuration file
Before running this script, create an Azure Container Registry account within your subscription.
Update all the parameter values in the below command.

DISCLAIMER
The sample script are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages

```
az devops service-endpoint create 	--service-endpoint-configuration @"linkedserviceacr.json"
                                  	--organization "https://dev.azure.com/myorg/" 
					--project myproject
```

Click on the `Browse code` to refer the `linkedserviceacr.json` file.
