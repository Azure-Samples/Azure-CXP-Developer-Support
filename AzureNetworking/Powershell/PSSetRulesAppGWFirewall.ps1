//DISCLAIMER
//The sample scripts are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such damages 

// Code Overview and Pre-requisites
// This sample script uses the most recent version of Az.Network module to set the new rules in Azure ApplicationGateway WebApplication FirewallConfiguration
// Create an ApplicationGateway WebApplication within your Azure Subscription with WAF v2 tier enabled
// Update all the variables in the below script



//Sample script

// Firstly you need to run the script to nullify the WAF config

$SubscriptionId = ''
$ResourceGroupName = ''
$GatewayName = ''
Connect-AzAccount -Subscription $SubscriptionId
$AppGw = Get-AzApplicationGateway -ResourceGroupName $ResourceGroupName -Name $GatewayName
$AppGw.webApplicationFirewallConfiguration = $null
Set-AzApplicationGateway -ApplicationGateway $AppGw

// Below commands to set the new rules:

$AppGW = Get-AzApplicationGateway -Name $GatewayName -ResourceGroupName $ResourceGroupName
$MyRules=New-AzApplicationGatewayFirewallDisabledRuleGroupConfig -RuleGroupName REQUEST-911-METHOD-ENFORCEMENT -Rules 911100
Set-AzApplicationGatewayWebApplicationFirewallConfiguration -ApplicationGateway $AppGW -Enabled $true -FirewallMode Detection -RuleSetVersion 3.2 -RuleSetType OWASP -DisabledRuleGroups $MyRules
Set-AzApplicationGateway -ApplicationGateway $AppGW

// To fetch the firewall configuration details, run the below PS script:

$AppGW = Get-AzApplicationGateway -Name $GatewayName -ResourceGroupName $ResourceGroupName
$FirewallConfig = Get-AzApplicationGatewayWebApplicationFirewallConfiguration -ApplicationGateway $AppGW
$FirewallConfig
