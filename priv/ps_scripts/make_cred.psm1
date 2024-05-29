function New-Cred
{
  param(
    [string]$userName,
    [string]$password
  )
  $pass = ConvertTo-SecureString $password -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($userName, $pass)

  return $cred
}
