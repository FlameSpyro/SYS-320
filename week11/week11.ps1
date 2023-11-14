# Eric Burdick
# Week 11: Incident Response Toolkit.
# Storyline: Create a script that looks for running processes + 4 of our choice and have it exported, saving the files into a zip file.
# REMEMBER TO USE FUNCTIONS

# Variables for convenient sake
$saveinput = Read-Host "Where would you like to save the results?"
$findcsv = Get-ChildItem -Path $saveinput -Filter *.csv

# Gather running processes
function Get-RunProcess {
Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$saveinput\run_process.csv" -NoTypeInformation
}

# Gather registered services and their paths to the exe
function Get-RegiServ {
Get-WmiObject -Class Win32_Service | Select-Object Name, PathName | Export-Csv -Path "$saveinput\registerd_services.csv" -NoTypeInformation
}

# Gather TCP network sockets
function Get-TCPSocks {
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Export-Csv -Path "$saveinput\tcpsocks.csv" -NoTypeInformation
}

# Gather user accounts
function Get-GetUser {
Get-WmiObject -Class Win32_UserAccount | Select-Object Name, FullName, Disabled, PasswordChangeable, PasswordExpires | Export-Csv -Path "$saveinput\userinfo.csv" -NoTypeInformation
}

# Choose 4 Artifacts

function Get-ChoiceFour {
# Get-PSDrive allows for the current status for all drives. This can be recorded in the case of a massive jump in loss or gain or storage.
Get-PSDrive | Export-Csv -Path "$saveinput\drivestats.csv" -NoTypeInformation

# NetFirewallRule shows configurations made or currently set for verification purposes.
Get-NetFirewallRule | Export-Csv -Path "$saveinput\firewallstats.csv" -NoTypeInformation

# Get-EventLog allows for the capture of a set amount of changes done to the computer. This can allow for a way of IDS to chack user activity and changes
Get-EventLog -LogName Security -Newest 15 | Export-Csv -Path "$saveinput\securitylogs.csv" -NoTypeInformation

# You can do the same but look more towards system aswell for the same results
Get-EventLog -LogName System -Newest 15 | Export-Csv -Path "$saveinput\systemlogs.csv" -NoTypeInformation
}


# Calling all functions! Last stop the desktop!
Get-RunProcess
Get-RegiServ
Get-TCPSocks
Get-GetUser
Get-ChoiceFour

# Now that we have all the data we want, we are going to now want to create a FileHash
# A foreach will ensure all files get skimmed through and run the proper hash code
foreach ($file in $findcsv) {
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA1
    "$($hash.Hash)  $($file.Name)" | Out-File -FilePath "$saveinput\checksums.txt" -Append
}

# Compress the archive to a ZIP file
$zipFile = "$saveinput\..\Results.zip"
Compress-Archive -Path $saveinput -DestinationPath "$saveinput\..\Results.zip"

# We need to make another checksum for the ZIP too!
$ZHash = Get-FileHash -Path $zipFile -Algorithm SHA1
"$($ZHash.Hash)  Results.zip" | Out-File -FilePath "$saveinput\..\ZChecksum.txt"
