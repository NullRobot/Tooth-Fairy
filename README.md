# sumnetcap.sh
# Summarize-Network-Capture
This bash script looks for interesting data in network capture files (pcap, pcapng, etc.) such as login credentials URLs, and PII. It also summarizes the network capture including showing complete TCP streams. This makes it easy to analyze captures quickly.

#Dependencies
You must have TSHARK installed for the script to work

# Usage
./sumnetcap.sh <path_to_pcapng_file>
