# Eric Burdick
# Storyline: Code to login to a SSH server


# Login to a remote SSH server
$login = New-SSHSession -ComputerName '184.171.144.93' -Credential (Get-Credential)
$SessionID = $login.SessionId

while ($True) {

    # Prompt to run commands
    $cmd = read-host -prompt "Enter a command"

    # Exit Prompt
    if ($cmd -eq "exit"){
        Write-Host "Ending the SSH session"

        # End the used SSH session
        Remove-SSHSession $SessionID
        exit
    }
    
    Write-Host ""

    # Run the command on remote SSH server
    (Invoke-SSHCommand -index $SessionID $cmd).Output
    Write-Host ""

}
