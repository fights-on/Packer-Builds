If ($env:PACKER_BUILDER_TYPE -eq "virtualbox-iso"){
    certutil.exe -addstore -f "TrustedPublisher" A:\oracle-cert.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha256-r3.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha256.cer
    certutil.exe -addstore -f "TrustedPublisher" E:\cert\vbox-sha1.cer
    E:\VBoxWindowsAdditions.exe /S
}