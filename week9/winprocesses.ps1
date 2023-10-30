# Eric Burdick
# Storyline: Exploring process, services, and WMI Objects


# Video Prompt: Take service and only how basic net details
# DNS, DHCP, IP address
Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object ServiceName, DHCPServer, IPAddress, DNSServerSearchOrder

# List all processes/serivces and export it to desktop
Get-Process | Select-Object ProcessName | Export-Csv -Path "C:\Users\champuser\Desktop\processes.csv" -NoTypeInformation
Get-Service | Select-Object ServiceName | Export-Csv -Path "C:\Users\champuser\Desktop\services.csv" -NoTypeInformation

# Start the calculator and then close it
# I cant seem to get it to close, the process isnt listing at all
Start-Process -FilePath calc.exe
Start-Sleep -Seconds 3
Get-Process -Name Calculator | Stop-Process
