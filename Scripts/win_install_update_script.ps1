
Install-PackageProvider NuGet -Force
Import-PackageProvider Nuget -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module PSWindowsUpdate -Force
If (!(Test-Path $home\Documents\WindowsPowershell.exe\Scripts)){New-Item $home\Documents\WindowsPowershell\Scripts -Type Directory -ErrorAction SilentlyContinue}
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/fights-on/update-scripts/master/Windows/windows.ps1' -OutFile $home\Documents\WindowsPowershell\Scripts\windows_update.ps1
New-Item -Path $PROFILE.CurrentUserAllHosts -Type File -ErrorAction SilentlyContinue
Add-Content -Path $PROFILE.CurrentUserAllHosts 'Import-Module $home\Documents\WindowsPowershell\Scripts\windows_update.ps1'