# Eric Burdick
# Storyline: Review the Security Event Log

# List all the available Windows Event Logs
Get-EventLog -list
Write-Host ""

# Create a few prompts to allow the user to specify the Log to view
$readLog = Read-host -Prompt "[*] Please select a log to review from the list above"

# Specify a keyword you are looking for in the log
$SearchW = Read-Host -Prompt "[*] Wathca lookin for?"

# Save the results to a directory
$myDir = Read-Host -Prompt "[*] Where do you want to save this?"

# Print results for the logs
Get-EventLog -LogName $readLog | where {$_.Message -ilike "*$SearchW*"} |export-csv -NoTypeInformation -Path "$myDir\$readLog.csv"
