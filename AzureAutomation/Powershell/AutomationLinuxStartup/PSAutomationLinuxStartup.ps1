# DISCLAIMER
# The sample script are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

# Script Overview and Pre-requisites
# This sample script is for the setting up an automation account runbook to start up a linux vm
# Before running this script, create an Azure VM and an Automation account within your subscription.
# Update all the variable details in the below code before running the sample.


# Sample Script
###############################################################################################

Import-Module Az.Compute  
$DebugPreference='Continue'
$resourceGroup = 'MyRGName'
$VMName = 'MyVMName'
$automationAccount = "MyAutomationAccount"

# Ensures you do not inherit an AzContext in your runbook
Disable-AzContextAutosave -Scope Process

# Connect to Azure with system-assigned managed identity
$AzureContext = (Connect-AzAccount -Identity).context

# set and store context
$AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext

Write-Output "Using system-assigned managed identity"

$vm = Get-AzVM -ResourceGroupName $resourceGroup -Name $VMName -Status -DefaultProfile $AzureContext

# Get current state of VM
$status = ($vm).Statuses[1].Code

Write-Output "`r`n Beginning VM status: $status `r`n"

Start-AzVM -Name $VMName -ResourceGroupName $resourceGroup -DefaultProfile $AzureContext

# Get new state of VM
$status = (Get-AzVM -ResourceGroupName $resourceGroup -Name $VMName -Status `
    -DefaultProfile $AzureContext).Statuses[1].Code  

Write-Output "`r`n Ending VM status: $status `r`n `r`n"

Write-Output "Account ID of current context: " $AzureContext.Account.Id

###############################################################################################

$ScriptToRun = "/home/MyUserName/script.sh"
Out-File -InputObject $ScriptToRun -FilePath MyScript.sh
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -Name $VMName -CommandId 'RunShellScript' -ScriptPath script.sh
Remove-Item -Path script.sh
