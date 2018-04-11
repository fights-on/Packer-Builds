function Delete-Directory($directory){
    Get-ChildItem -Path $directory -Recurse | Remove-Item -Force -Recurse
    Remove-Item $directory -Force
}

net stop wuauserv
Delete-Directory C:\Windows\SoftwareDistribution\Download
New-Item -Path C:\Windows\SoftwareDistribution\Download -Type Directory
net start wuauserv

C:\Windows\Temp\udefrag.exe --optimize --repeat C:
C:\Windows\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f
C:\Windows\Temp\sdelete64.exe -q -z C:
