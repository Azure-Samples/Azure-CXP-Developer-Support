---
page_type: sample
languages:
- powershell
products:
- azure-storage	
---


# Powershell script to fetch the ContentMD5 property of the Blob

 Code Overview and Pre-requisites
 
 This powershell sample script helps to fetch the the ContentMD5 property of the Blob.
 From Az.Storage 5.0.0 (released on 2022-10-17), the Get-AzStorageBlob has the returned blob properties moved from ICloudBlob.Properties to BlobProperties. 
 The `ICloudBlob.Properties.ContentMD5` matches to `BlobProperties.ContentHash`.
 Before running this, you need to create an Azure Storage account within your Azure Subscription.
 Create a Container within your storage account and upload a blob which has the ContentMD5 as its property.
 Update all the variable details in the below script before running the sample.
 
 
DISCLAIMER
 The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
$context = New-AzStorageContext -ConnectionString "StorageConnectionString" 

# with Az.Storage 5.0.0 and later, you can get the original contentMD5 property value with script 
 
[Convert]::ToBase64String((get-azstorageblob -Context $ctx -Container finpacksetup -Blob "us/myBlobName.txt").BlobProperties.ContentHash)


# Another alternative way is to run ICloudBlob.FetchAttributes(), then you can still get ContentMD5 in the original place.

$blob = get-azstorageblob -Context $ctx -Container finpacksetup -Blob "us/myBlobName.txt"
$blob.ICloudBlob.FetchAttributes()
$blob.ICloudBlob.Properties.ContentMD5

```
