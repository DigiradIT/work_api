param([string]$password, [string]$targetGroup, [string]$targetAlias)

Import-Module ExchangeOnlineManagement

$userName = "runner@ttgimagingsolutions.com"
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($userName, $pass)

Connect-ExchangeOnline -Credential $cred

$group = Get-UnifiedGroup -Identity $targetGroup

$group | Set-UnifiedGroup -EmailAddress @{Add=$targetAlias}

