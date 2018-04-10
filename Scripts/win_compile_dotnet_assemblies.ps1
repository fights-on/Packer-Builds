c:\windows\microsoft.net\framework\v4.0.30319\ngen.exe update /force /queue > $null
c:\windows\microsoft.net\framework\v4.0.30319\ngen.exe executequeueditems > $null
If ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
    c:\windows\microsoft.net\framework64\v4.0.30319\ngen.exe update /force /queue > $null
    c:\windows\microsoft.net\framework64\v4.0.30319\ngen.exe executequeueditems > $null
}