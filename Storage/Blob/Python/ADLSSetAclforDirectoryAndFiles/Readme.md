---
page_type: sample
languages:
- python
products:
- azure-storage	
---


# Python sample code to set the ACL permissions on the files and directories and set owner and owner group for directory.

 Code Overview and Pre-requisites
 
 This sample code uses the azure.storage.filedatalake python module to perform the set acl permissions for data lake directory and files. Also set the owner and group permissions for the directory.
 Before running this, you need to ensure that the Azure Datalake Storage is created and have a file system created with directory and file in it. Also You need to have a user with a group created in your AAD.
 Update all the variable details in the below code before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 



//Sample Code

```
import os, uuid, sys
from azure.storage.filedatalake import DataLakeServiceClient
from azure.core._match_conditions import MatchConditions
from azure.storage.filedatalake._models import ContentSettings


# Set the Storage account connection string from the environment variable
conn_str = "XXXXXXXXXXXXX"

# Create the service client with the connection string
service_client = DataLakeServiceClient.from_connection_string(conn_str=conn_str)

        
# Create a file system client
file_system_client = service_client.get_file_system_client(file_system="MyFileSystemName")

#try:
# Create a directory client
dir_client = file_system_client.create_directory("MyDirectoryName")

# Create a file client
file_client = dir_client.get_file_client("MyFileName.txt")

# set the permissions of the parent directory
new_dir_permissions = 'rwx------'
dir_client.set_access_control(permissions=new_dir_permissions)

# Set and display the Owner and Owner Group
# If you want to set the Owner and Group, You can pass it as a parameter to set_access_control(). see dir_client.set_access_control(owner="OwnerOID", group="MyGroupName")

acl_props = dir_client.get_access_control()
print("New permissions of directory '{}' are {}.".format("MyDirectoryName", acl_props['permissions']))

file_client.set_access_control(permissions=new_dir_permissions)

print("Set the permissions of file '{}' to {}.".format("MyFileName.txt", new_dir_permissions))

```
