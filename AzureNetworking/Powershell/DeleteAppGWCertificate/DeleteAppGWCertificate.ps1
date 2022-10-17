# DISCLAIMER
# The sample codes are not supported under any Microsoft standard support program or service. The sample codes are provided AS IS without warranty of any kind. Microsoft further disclaims //all implied warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out of the use or //performance of the sample codes and documentation remains with you. In no event shall Microsoft, its authors, owners of this repository or anyone else involved in the creation, //production, or delivery of the scripts be liable for any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of business //information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, even if Microsoft has been advised of the possibility of such //damages

Connect-AzureRmAccount
$appgwName = "AppGateway-APIM"
$resgpName = "sf-with-apim-rg"
$gw = Get-AzureRmApplicationGateway -Name $appgwName -ResourceGroupName $resgpName
$gw = Remove-AzureRmApplicationGatewayTrustedRootCertificate -ApplicationGateway $gw -Name "proxySettings_trustedRootCertificates_fbb481bd-5af9-4138-a25c-4e"
$gw = Set-AzureRmApplicationGateway -ApplicationGateway $gw
$gw = Remove-AzureRmApplicationGatewayTrustedRootCertificate -ApplicationGateway $gw -Name "proxySettings_trustedRootCertificates_1e11891c-3c7a-488c-b0fd-08"
$gw = Set-AzureRmApplicationGateway -ApplicationGateway $gw
$gw = Remove-AzureRmApplicationGatewayTrustedRootCertificate -ApplicationGateway $gw -Name "proxySettings_trustedRootCertificates_d28d970e-8394-475d-9b41-0f"
$gw = Set-AzureRmApplicationGateway -ApplicationGateway $gw

Remove-AzureRmApplicationGatewaySslCertificate -ApplicationGateway $gw -Name "appgatewaycert"
Remove-AzureRmApplicationGatewaySslCertificate -ApplicationGateway $gw -Name "proxycert"
Remove-AzureRmApplicationGatewaySslCertificate -ApplicationGateway $gw -Name "proxycertwithchain"
