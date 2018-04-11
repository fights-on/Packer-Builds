If ($env:PACKER_BUILDER_TYPE -eq "virtualbox-iso") {
    certutil.exe -addstore -f "TrustedPublisher" A:\oracle-cert.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha256-r3.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha256.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha1.cer
    E:\VBoxWindowsAdditions.exe /S
} ElseIF ($env:PACKER_BUILDER_TYPE -eq "vmware-iso") {
  if (Test-Path "C:\Users\vagrant\windows.iso") {
    Move-Item -Path "C:\Users\$env:USERPROFILE\vagrant\windows.iso" -Destination "C:\Windows\Temp"
  }
  if (!(Test-Path "C:\Windows\Temp\windows.iso")) {
    (New-Object System.Net.WebClient).DownloadFile("http://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.5.9/7535481/windows/packages/tools-windows.tar", "C:\Windows\Temp\vmware-tools.tar")
    & "C:\Program Files\7-Zip\7z.exe" x C:\Windows\Temp\vmware-tools.tar -oC:\Windows\Temp
    Get-ChildItem -Path C:\Windows\Temp -Filter "VMware-tools-windows-*.iso" | Rename-Item -NewName windows.iso
    Remove-Item -Recurse -Force C:\Program Files (x86)\VMWare
  }
  & "C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\windows.iso" -oC:\Windows\Temp\VMWare
  & "C:\Windows\Temp\VMWare\setup.exe" /S /v /qn REBOOT=R
  Remove-Item "C:\Windows\Temp\vmware-tools.tar"
  Remove-Item "C:\Windows\Temp\windows.iso"
  Remove-Item "C:\Windows\Temp\VMware"
}
