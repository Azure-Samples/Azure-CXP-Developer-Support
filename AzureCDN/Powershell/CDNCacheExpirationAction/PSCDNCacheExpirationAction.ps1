# DISCLAIMER
# The sample script are not supported under any Microsoft standard support program or service. The sample script are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

# Script Overview and Pre-requisites
# This sample script uses the Az.CDN module to create a CacheExpirationAction.
# Before running this, you need to create an Azure CDN resource within your Azure Subscription.
# Update all the variable details in the below code before running the sample.


# Sample Code

$ruleCacheAction=[Microsoft.Azure.PowerShell.Cmdlets.Cdn.Models.Api20210601.DeliveryRuleCacheExpirationAction]::New()
$ruleCacheAction.Name=[Microsoft.Azure.PowerShell.Cmdlets.Cdn.Support.DeliveryRuleAction]::CacheExpiration
$ruleCacheAction.ParameterCacheDuration="1.00:00:00"
$ruleCacheAction.ParameterCacheBehavior=[Microsoft.Azure.PowerShell.Cmdlets.Cdn.Support.CacheBehavior]::SetIfMissing


$profileName="MyProfile"
$rgName = "MyRgName"
$name = "EndpointName"

$cdnEndpoint = Get-AzCdnEndpoint -ProfileName $profileName -ResourceGroupName $rgName -Name $name
$cond1 = New-AzCdnDeliveryRuleCookiesConditionObject -Name Cookies -ParameterOperator Equal -ParameterSelector test -ParameterMatchValue test -ParameterNegateCondition $False -ParameterTransform Lowercase
$rule = New-AzCdnDeliveryRuleObject -Action @($ruleCacheAction) -Order 1 -Name "Caching" -Condition @($cond1)
Update-AzCdnEndpoint -ProfileName $profileName -ResourceGroupName $rgName -Name $name -DeliveryPolicyRule @($rule)
