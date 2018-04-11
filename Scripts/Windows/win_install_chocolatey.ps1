New-Item -Path $home\Documents\WindowsPowerShell -Type Directory -ErrorAction SilentlyContinue
New-Item -Path $home\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 -Type File -ErrorAction SilentlyContinue
New-Item -Path $PROFILE.CurrentUserAllHosts -Type File -ErrorAction SilentlyContinue
Add-Content -Path $home\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1 '# Microsoft.PowerShell_profile.ps1'
Add-Content -Path $PROFILE.CurrentUserAllHosts '$env:Path += ";C:\ProgramData\chocolatey\bin"'
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) > $null
