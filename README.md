# sumnetcap.sh
# Summarize-Network-Capture
This bash script looks for interesting data in network capture files (pcap, pcapng, etc.) such as login credentials, PII. It also summarizes the network capture making it easy to analyze captures quickly.

#Dependencies
You must have TSHARK installed for the script to work

# Usage
./sumnetcap.sh <path_to_pcapng_file>
