# sumnetcap.sh
# Summarize-Network-Capture
This bash script is designed to analyze a network capture file in pcapng,pcap, and other formats accepted by tshark. It provides several functions to extract and summarize different types of data from the capture file, including strings, credentials, TCP/UDP stream summaries, overall activity summaries, and searches for sensitive information like Social Security numbers, email addresses, driver's licenses, and passport numbers.

To use this script, follow these steps:

1. Make sure you have `tshark` installed on your system, as it is used for analyzing the pcapng file.
2. Save the script to a file, for example, `analyze_pcapng.sh`.
3. Make the script executable by running the command `chmod +x analyze_pcapng.sh`.
4. Execute the script by providing the path to your pcapng file as an argument: `./analyze_pcapng.sh path_to_your_pcapng_file`.

The script will check if the file path is provided and if the file exists. If these checks pass, it will proceed to execute the functions defined within the script, outputting the results to the terminal. Each function is responsible for a specific type of analysis, and they will run in sequence when the script is executed.

# Dependencies
You must have TSHARK installed for the script to work.
This runs on any OS that supports running bash including Linux, Unix, Mac OS, and Windows with Cygwin or Windows with WSL Linux.

# Usage
./sumnetcap.sh <path_to_pcapng_file>
