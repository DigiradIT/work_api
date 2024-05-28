param([string]$password)

$userName = "runner@ttgimagingoslutions.com"
$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($userName, $pass)
