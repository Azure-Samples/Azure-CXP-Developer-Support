---
page_type: sample
languages:
- powershell
products:
- azure-virtual-machines  
---
 
 
# Powershell script to automate on-demand backup of azure virtual machines
 
Code Overview and Pre-requisites
 
This powershell sample script helps to trigger on-demand backup of azure virtual machine.
Update all the variable details in the below script before running the sample.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 
 
 
```
<#
    .DESCRIPTION
        An example runbook which takes On-demand backup of Azure VM by Azure Backup in a subscription using Managed Identity

    .NOTES
        AUTHOR: Azure Backup
#>
Param 
(    
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] 
    [String] 
    $AzureSubscriptionId, 
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()] 
    [Int] 
    $RetentionDays = 30
) 

"Please enable appropriate RBAC permissions to the managed identity"

try {
    "Logging in to Azure..."
    Connect-AzAccount
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

Set-AzContext -Subscription $AzureSubscriptionId

$Time = Get-Date
$DateTime = $Time.ToUniversalTime().AddDays($RetentionDays)
Write-Output ("Recoverypoints will be retained till " + $DateTime)
$jobList = @()
$vaultList =@()

$vaults = Get-AzRecoveryServicesVault 

foreach ($vault in $vaults) {
    $vaultname = Get-AzRecoveryServicesVault -Name $vault.Name
    Get-AzRecoveryServicesVault -Name $vault.Name | Set-AzRecoveryServicesVaultContext
    Write-Output ("Setting the vault context : " + $vaultname.Name)

    $namedContainers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM
    Write-Output ("Got # of Backup Containers: " + $namedContainers.Count)

    foreach ($namedContainer in $namedContainers) {
        Write-Output ("Working on container: " + $namedContainer.FriendlyName)

        $item = Get-AzRecoveryServicesBackupItem -Container $namedContainer -WorkloadType AzureVM
        Write-Output ("Backing up virtual machine: " + $item.Name)

        $job = Backup-AzRecoveryServicesBackupItem -Item $item -ExpiryDateTimeUTC $DateTime
    }
}
```
