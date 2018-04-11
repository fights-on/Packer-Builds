Write-Host "Set WinRM start type to auto"
Set-Service -Name "winrm" -StartupType "Automatic"
