param([string]$content, [string]$fileName, [string]$path)

$content | Out-File -FilePath "$path/$fileName" -Append
