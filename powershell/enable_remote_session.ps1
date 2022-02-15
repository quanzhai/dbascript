# https://www.techtutsonline.com/windows-powershell-remoting/

# To enable
Enable-PSRemoting -Force
winrm quickconfig -quiet
Set-Item WSMan:\\localhost\client\TrustedHosts -Value "scb-pr-codbn71.scb.osl.basefarm.net" -Concatenate -Force

# Verify
Get-Item WSMan:\\localhost\client\TrustedHosts
Enter-PSSession -ComputerName "scb-pr-codbn72.scb.osl.basefarm.net" -Credential "mgmt\quanz"