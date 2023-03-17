---
page_type: sample
languages:
- python
products:
- azure-storage	
---


# Python sample code to upload the blob to Azurite by using the SAS token

 Code Overview and Pre-requisites
 
 This sample code uses the azure.storage.blob python module to perform the blob upload operation to Azurite via SAS token.
 Before running this, you need to ensure that the Azurite is installed and running in the background. Have the python modules installed in your environment.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 



//Sample Code

```
from datetime import datetime, timedelta
import requests
from azure.storage.blob import BlobSasPermissions, BlobServiceClient, generate_blob_sas

# Update all the below variables for Azure Storage
connect_str = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;"
container_name = "files"
blob_name = "myblob.log"
account_key = "Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=="

# Blob Service client object
blob_service_client = BlobServiceClient.from_connection_string(connect_str)
blob_client = blob_service_client.get_blob_client(
    container=container_name, blob=blob_name
)

# Update the right permissions for your SAS token 
sas_permissions = BlobSasPermissions(read=True, write=True, delete=False, list=True)

# Update the start time and expiry time for SAS token
sas_start_time = datetime.utcnow()
sas_expiry_time = sas_start_time + timedelta(hours=1)

# Generate the Azure Blob Storage SAS token
sas_token = generate_blob_sas(
    account_name=blob_service_client.account_name,
    account_key=blob_service_client.credential.account_key,
    container_name=container_name,
    blob_name=blob_name,
    permission=sas_permissions,
    start=sas_start_time,
    expiry=sas_expiry_time
)

upload_url = blob_client.url + "?" + sas_token
print(upload_url)

# Read the concerned blob
local_path = "myblob.log"

# Read the file contents
with open(local_path, "rb") as file:
    file_contents = file.read()

headers = {
    "x-ms-blob-type": "BlockBlob",
    "Content-Type": "application/octet-stream",
    "Content-Length": str(len(file_contents)),
}

# Upload the blob
response = requests.put(upload_url, data=file_contents, headers=headers)

# print the blob upload http status code
print(response.status_code)

```
