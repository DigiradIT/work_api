param([string]$userName, [string]$password, [string]$targetGroup, [string]$targetAlias)

Import-Module ExchangeOnlineManagement
Import-Module ($pwd.Path + "/make_cred.psm1")

$cred = New-Cred -userName $userName -password $password

Connect-ExchangeOnline -Credential $cred

$group = Get-UnifiedGroup -Identity $targetGroup

$group | Set-UnifiedGroup -EmailAddress @{Add=$targetAlias}

