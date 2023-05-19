---
page_type: sample
languages:
- powershell
products:
- azure-virtual-machines
---


# PowerShell script to monitor the scripts that were executed using `Invoke-AzVMRunCommand` PS cmdlet on Azure Virtual Machine


Script Overview and Pre-requisites:

This sample PS script monitors the script that is run using `Invoke-AzVMRunCommand` on Azure Virtual Machine. 
This script uses the `Start-Sleep` cmdlet to pause the script execution for a specified amount of time and then check if our command has completed.
Please find below an example which leverages the Start-Sleep cmdlet to set a timeout value of 1800 seconds (30 minutes) for the Invoke-AzVMRunCommand cmdlet.
Before running this, you need to ensure that you have a PS file named script.ps1 with the relevant content and you have access to the Azure Virtual machine.
Update all the variable details in the below code before running the sample.

DISCLAIMER
The sample script are not supported under any Microsoft standard support program or service. The sample script are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

```
# Sample Script

$timeout = 1800
$startTime = Get-Date

$result = Invoke-AzVMRunCommand -ResourceGroupName "myResourceGroup" -VMName "myVM" -CommandId "RunPowerShellScript" -ScriptPath "C:\Scripts\MyScript.ps1"

while (($result.Status -ne "Succeeded") -and ((Get-Date) - $startTime).TotalSeconds -lt $timeout) {
    Start-Sleep -Seconds 10
    $result = Get-AzVMRunCommand -ResourceGroupName "myResourceGroup" -VMName "myVM" -CommandId $result.CommandId
}

if ($result.Status -eq "Succeeded") {
    # Do something with the $result. 
}
else {
    # print the error / exceptions if it fails.
}
```
