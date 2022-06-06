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

