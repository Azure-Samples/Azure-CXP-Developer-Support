# DISCLAIMER
# The sample script are not supported under any Microsoft standard support program or service. The sample script are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

# Script Overview and Pre-requisites
# This sample script uses the Az.Compute module to Query the Azure VM and remove the User from multiple Azure VMs across the subscriptions
# Before running this, you need to ensure that you have a PS file named script.ps1 with the content-- Remove-LocalUser -Name 'testUserName'
# Update all the variable details in the below code before running the sample.


# Sample Code

$ErrorActionPreference = "continue"

try {

Connect-AzAccount

$Subscriptions = Get-AzSubscription

foreach ($sub in $Subscriptions) {

    Write-Host -ForegroundColor Blue "checking under subscription" + $sub

    #Setting context so the script will be executed within the subscription's scope
    Get-AzSubscription -SubscriptionName $sub.Name | Set-AzContext

    Get-AzSubscription -subs -SubscriptionId $sub.Name | Set-AzContext
     Select-AzSubscription -SubscriptionId 'b83c1ed3-c5b6-44fb-b5ba-2b83a074c23f'
       
    #Listing the Resource Groups from the subscription.
    $resourceGroupList = Get-AzResourceGroup | select ResourceGroupName

    if($resourceGroupList -ne $null)
    {

            foreach ($RG in $resourceGroupList) {

            Write-Host -ForegroundColor Cyan "checking for Virtual Machines under ResourceGroup" + $RG.ResourceGroupName

            #List the VM resources in the Resource Group
            $VMList = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines -ResourceGroupName $RG.ResourceGroupName | Select Name 
    
            foreach ($vmName in $VMList) 
            {
                $provisioningState = (Get-AzVM -resourcegroupname $RG.ResourceGroupName -name $vmName.Name -Status).Statuses[1].Code
                if($provisioningState -eq "PowerState/running")
                {
                    Write-Host -ForegroundColor Yellow "Removing the user from VM" + $vmName.Name

                   #Ensure that you have a PS file named script.ps1 with the content---- Remove-LocalUser -Name 'testUserName'
                   Invoke-AzVMRunCommand -ResourceGroupName $RG.ResourceGroupName -Name $vmName.Name -CommandId 'RunPowerShellScript' -ScriptPath .\script.ps1
                }

            }

         }

      }
    
  }

}

catch {
    Write-Host "$($_.Exception.Message)" -BackgroundColor DarkRed
}
