---
page_type: sample
languages:
- powershell
products:
- azure-resource-manager  
---
 
 
# Powershell script to retrieve the created date of the azure resources
 
Code Overview and Pre-requisites
 
This powershell sample script helps to fetch the created date of the azure resources which you have access to.
 
 
DISCLAIMER
The sample code are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 
 
 
```

try {
    "Logging in to Azure..."
    Connect-AzAccount 
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}


$managementgroups = (Get-AzManagementGroup).Name
foreach ($mg in $managementgroups) {
    
    $subscriptionList = (Get-AzManagementGroupSubscription -GroupName $mg).Id
    
    $subscriptions = $subscriptionList.Substring($subscriptionList.Length - 36, 36)

    foreach ($s in $subscriptions) {
        Write-Output ("Setting Current context with " + $s)
        Set-AzContext -Subscription $s
        $ResourceGroups = Get-AzResourceGroup 

        foreach ($ResourceGroup in $ResourceGroups) {    
            $m = @()
            Write-Output ("Showing resources in resource group " + $ResourceGroup.ResourceGroupName)
            $resources = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName
            foreach ($resource in $resources) {
                $log = Get-AzActivityLog -ResourceGroupName $ResourceGroup.ResourceGroupName | Where-Object {$_.OperationName -Like "Create*" -and  $_.resourceId -eq $resource.Id}
                $caller = $log.Caller
                $r = Get-AzResource -ResourceGroupName $ResourceGroup.ResourceGroupName -Name $resource.Name -ExpandProperties| Select-Object Name , ResourceGroupName, CreatedTime 
                $object = New-Object psobject
                $object | Add-Member NoteProperty Name $r.Name 
                $object | Add-Member NoteProperty ResourceGroupName $r.ResourceGroupName
                $object | Add-Member NoteProperty CreatedTime $r.CreatedTime
                $object | Add-Member NoteProperty Caller $caller

                $m += $object

            }
            $m | Format-Table
        } 

    }

}
```
