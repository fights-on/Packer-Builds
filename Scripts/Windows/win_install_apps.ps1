# Ensure C:\Chocolatey\bin is on the path
$env:Path += ";C:\ProgramData\chocolatey\bin"

# Install all the things; for example:
choco upgrade -y all
choco install -y notepadplusplus.install
choco install -y 7zip.install