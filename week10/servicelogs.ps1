# Eric Burdick
# Storyline: Prompt a selection to view running, stopped, and running services


# A while loop will maintain the program. If we're done with the program then the loop will switch to false.

while ($true) {
    $input = Read-Host "Hello! Would you like to view `running`, `stopped`, `all` services? Or type `quit` if your all set!"

    # Depending on what is chosen, the answer runs through the switch and runs the proper answer
    switch ($input) {
        'running' {
            Get-Service | Select-Object DisplayName, Status | Where-Object {$_.Status -eq 'Running'} | Format-Table
        }
        'stopped' {
            Get-Service | Select-Object DisplayName, Status | Where-Object {$_.Status -eq 'Stopped'} | Format-Table
        }
        'all' {
            Get-Service | Select-Object DisplayName, Status | Format-Table
        }
        'quit' {
            Write-Host "See ya later!"
            exit
        }
        default {
            # Invalid option message for unknown value
            write-Host
            Write-Host "[-] Sorry, that doesnt sound right. Please make sure you spelled it properly."
        }
    }
}
