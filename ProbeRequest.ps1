# Paths
$tsharkPath = "C:\Program Files\Wireshark\tshark.exe"
$outputPath = "probe_requests.csv"

# Column headers
$headers = "Time|Source|Info"

# Hashtables to store counts
$ssidCount = @{}
$macCount = @{}

# Function to get the top 5
function Get-Top5 {
    param (
        [hashtable]$countTable
    )
    $countTable.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5
}

# Function to show results
function Show-Results {
    Write-Host "`nTop 5 WLAN networks:"
    Get-Top5 $ssidCount | ForEach-Object { Write-Host "$($_.Name): $($_.Value)" }

    Write-Host "`nTop 5 MAC addresses:"
    Get-Top5 $macCount | ForEach-Object { Write-Host "$($_.Name): $($_.Value)" }
}

# Function to start capturing probe requests
function Start-Capture {
    param(
        [string]$interfaceIndex,
        [string]$interfaceName
    )
    try {
        Write-Host "Starting capture on interface $interfaceIndex ($interfaceName)..."
        
        # Add headers to the output file
        $headers | Out-File -FilePath $outputPath -Encoding utf8
        
        # Capture probe requests using tshark
        & $tsharkPath -i $interfaceIndex -I -Y "wlan.fc.type_subtype == 0x04" `
        -T fields -e frame.time -e wlan.sa -e _ws.col.Info `
        -E header=n -E separator='|' 2>$null |
        
        # Process each line of the output in real time
        ForEach-Object {
            # Filter out lines containing 'SSID=Wildcard'
            if ($_ -notmatch "SSID=Wildcard") {
                # Remove 'Romance Daylight Time'
                $cleanedLine = $_ -replace "Hora de verano romance|Romance Daylight Time|Romance Standard Time", ""
                
                # Split the cleaned line into parts
                $parts = $cleanedLine.Split('|')
                $rawDate = $parts[0].Trim()
                $mac = $parts[1].Trim()
                $info = $parts[2].Trim()

                # Convert the date to 'YYYY-MM-DD HH:MM:SS' format
                $date = Get-Date $rawDate -Format 'yyyy-MM-dd HH:mm:ss'
                
                # Extract SSID part
                if ($info -match 'SSID="([^"]+)"') {
                    $ssid = $matches[1]
                    # Create new line with formatted date, source, and only the SSID name
                    "$date|$mac|$ssid" | Add-Content -Path $outputPath
                    
                    # Count SSID occurrences
                    if ($ssidCount.ContainsKey($ssid)) {
                        $ssidCount[$ssid]++
                    } else {
                        $ssidCount[$ssid] = 1
                    }
                    
                    # Count MAC occurrences
                    if ($macCount.ContainsKey($mac)) {
                        $macCount[$mac]++
                    } else {
                        $macCount[$mac] = 1
                    }
                }
            }
        }
    } finally {
        Show-Results
        Write-Host "`nCapture complete. Results saved to $outputPath"
    }
}

# List available network interfaces
Write-Host "Available network interfaces:"
$interfaces = & $tsharkPath -D | ForEach-Object {
    if ($_ -match '(\d+)\.\s+(.+)') {
        [PSCustomObject]@{
            Index = $matches[1]
            Name = $matches[2]
        }
    }
}

$interfaces | ForEach-Object { Write-Host "$($_.Index). $($_.Name)" }

# User selects the interface
$interfaceIndex = Read-Host "Enter the correct interface index for tshark"

# Get the name of the selected interface
$selectedInterface = $interfaces | Where-Object { $_.Index -eq $interfaceIndex }

if ($selectedInterface) {
    # Start the probe request capture and save it to CSV
    Start-Capture $interfaceIndex $selectedInterface.Name
}
else {
    Write-Host "Invalid interface selection."
}
