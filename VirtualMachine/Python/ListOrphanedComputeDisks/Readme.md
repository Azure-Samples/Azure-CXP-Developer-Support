---
page_type: sample
languages:
- python
products:
- azure-virtual-machines
---


#  Python sample to list Orphaned compute disks

Code Overview and Pre-requisites
 
 This sample code uses the `azure.mgmt.compute` and `azure.mgmt.resource` python package to check if compute disk is managed or orphaned and then lists the orphaned disks.
 Before running this, before running the sample, ensure that you are using all updated python packages. Example: `pip install --upgrade azure-identity`
 Update all the variable details in the below code before running the sample.
 
 

DISCLAIMER

The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 


```
#!/usr/bin/env python3
import os
import json
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.resource import ResourceManagementClient

credential = DefaultAzureCredential()

subscription_id = "XXXX-XXXX-XXXX-XXXX"

compute_client = ComputeManagementClient(credential, subscription_id)
resource_client = ResourceManagementClient(credential, subscription_id)

# a list to store the names of orphaned disks
orphaned_disks = []

# iterate over all disks
for disk in compute_client.disks.list():
    # check if disk is managed, if not it's orphaned
    if disk.managed_by is None:
        # get the resource of the disk
        disk_resource = resource_client.resources.get_by_id(disk.id,api_version='2023-01-02')
        # check if resource type is a "disk" resource
        if disk_resource.type == 'Microsoft.Compute/disks':
            # add disk name to list
            orphaned_disks.append(disk.name)

# print list of orphaned disks
print("Orphaned disks:")
for disk in orphaned_disks:
    print(disk)
```

