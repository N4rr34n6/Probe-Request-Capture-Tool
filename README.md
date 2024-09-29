# Probe Request Capture Tool

This PowerShell-based tool captures wireless network probe requests using TShark (the command-line version of Wireshark), processes the data in real time, and stores the results in a CSV file. The tool provides detailed insights into WLAN networks and associated MAC addresses, making it useful for network diagnostics and analysis.

## Key Features

- **Real-time Probe Request Capture**: Captures WLAN probe requests in real time using TShark on a specified network interface.
- **SSID and MAC Address Analysis**: Extracts and counts occurrences of SSIDs (wireless network names) and MAC addresses (device identifiers) from probe requests.
- **Top 5 Networks and MACs**: Displays the top 5 most frequently detected SSIDs and MAC addresses during the capture session.
- **CSV Output**: Saves the captured data, including timestamps, MAC addresses, and SSIDs, to a CSV file for further analysis.
- **Network Adapter Information**: Lists all available network interfaces for easy selection.

## Requirements

- **Wireshark/TShark**: TShark must be installed and accessible on your system. You can download it from the official Wireshark website: https://www.wireshark.org/download.html
- **PowerShell**: The script is designed to run in a PowerShell environment (Windows).

## Installation

1. Install TShark on your system.
2. Download or clone this repository to your local machine.
3. Ensure that the `$tsharkPath` variable in the script is correctly set to the location of your TShark installation.

## Usage

1. Open a PowerShell window as an administrator.
2. Run the script:
   ```powershell
   .\ProbeRequestCapture.ps1
   ```
3. The script will display all available network interfaces. Select the correct interface by entering its index.
4. The tool will then start capturing probe requests and display a summary of the top SSIDs and MAC addresses. The captured data will be saved in `probe_requests.csv`.

### Example

```plaintext
Available network interfaces:
1. Wi-Fi
2. Ethernet
3. Virtual Adapter

Enter the correct interface index for TShark: 1
Starting capture on interface 1 (Wi-Fi)...
```

During the capture process, the script will display live counts of the most common networks and devices detected. Once the capture is complete, it will generate a summary of the top 5 SSIDs and MAC addresses.

## CSV Output

The probe request data will be saved to `probe_requests.csv` with the following format:

| Time               | Source MAC         | SSID        |
|--------------------|--------------------|-------------|
| 2024-09-25 12:30:45| 00:14:22:01:23:45  | MyNetwork   |
| 2024-09-25 12:31:00| 00:25:36:78:54:21  | AnotherSSID |

## Important: System Language Consideration

The script includes a line to clean up time zone information from the capture output:
```powershell
$cleanedLine = $_ -replace "Hora de verano romance|Romance Daylight Time|Romance Standard Time", ""
```
This line specifically removes "Romance" time zone information from the data. Depending on your system's language settings, this may need to be adjusted. If your system is not using the Romance time zone or is in a different language, replace the string `"Hora de verano romance|Romance Daylight Time|Romance Standard Time"` with the appropriate time zone or language-specific terms used in your environment.

## Additional Features

- **Top 5 Summary**: The script provides a top 5 summary of the most frequent SSIDs and MAC addresses during the session.
- **Live Data Processing**: Captures and processes data in real-time for immediate feedback on network activity.
- **Flexible Interface Selection**: Lists available network adapters for easy selection, ensuring the correct interface is used for capture.

## Error Handling

The script includes basic error handling to manage issues such as invalid interface selections and errors during the capture process.

## Ethical Use and Legal Considerations

Please ensure you have proper authorization to monitor and capture wireless traffic on any network you use this tool on. Unauthorized monitoring of network traffic may be illegal in your jurisdiction.

## License

This project is provided under the GNU Affero General Public License v3.0. You can find the full license text in the [LICENSE](LICENSE) file.
