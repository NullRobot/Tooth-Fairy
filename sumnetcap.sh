#!/bin/bash
# Created by CameronHVoss@protonmail.com

# Check if a file path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_pcapng_file>"
    exit 1
fi

# Assign the first argument as the pcapng file path
PCAPNG_FILE="$1"

# Check if the file exists
if [ ! -f "$PCAPNG_FILE" ]; then
    echo "File not found: $PCAPNG_FILE"
    exit 1
fi

# Define a function to extract strings with at least 9 characters
extract_strings() {
    echo "Extracting strings from $PCAPNG_FILE with at least 9 characters..."
    strings "$PCAPNG_FILE" | awk 'length($0) > 8'
}

# Define a function to extract credentials for clear text protocols
extract_credentials() {
    echo "Searching for credentials in $PCAPNG_FILE for clear text protocols..."
    # HTTP Basic Auth
    tshark -r "$PCAPNG_FILE" -Y "http.authorization" -T fields -e http.authorization
    # FTP
    tshark -r "$PCAPNG_FILE" -Y "ftp.request.command == USER || ftp.request.command == PASS" -T fields -e ftp.request.arg
    # Telnet
    tshark -r "$PCAPNG_FILE" -Y "telnet.option_text" -T fields -e telnet.option_text
    # POP3
    tshark -r "$PCAPNG_FILE" -Y "pop.request.command == USER || pop.request.command == PASS" -T fields -e pop.request.arg
    # HTTP POST Form Data
    tshark -r "$PCAPNG_FILE" -Y "http.request.method == POST" -T fields -e http.file_data
}

# Define a function to summarize each TCP/UDP stream
summarize_streams() {
    echo "Summarizing TCP/UDP streams in $PCAPNG_FILE..."
    tshark -r "$PCAPNG_FILE" -q -z conv,tcp
    tshark -r "$PCAPNG_FILE" -q -z conv,udp
}

# Define a function to summarize the pcapng file
summarize_pcapng() {
    echo "Summarizing the activities in $PCAPNG_FILE..."
    tshark -r "$PCAPNG_FILE" -q -z io,phs
}

# Define a function to search for sensitive information like SSNs, emails, driver's licenses, and passport numbers
search_sensitive_info() {
    echo "Searching for sensitive information in $PCAPNG_FILE..."
    # Social Security numbers (format: XXX-XX-XXXX)
    tshark -r "$PCAPNG_FILE" -Y "data.data" -T fields -e data.data | grep -oE '[0-9]{3}-[0-9]{2}-[0-9]{4}'
    # Email addresses
    tshark -r "$PCAPNG_FILE" -Y "data.data" -T fields -e data.data | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}'
    # Driver license numbers (format varies by state, simple regex example)
    tshark -r "$PCAPNG_FILE" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{5,9}'
    # Passport numbers (format varies by country, simple regex example)
    tshark -r "$PCAPNG_FILE" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{6,9}'
}

# Call the functions
extract_strings
extract_credentials
summarize_streams
summarize_pcapng
search_sensitive_info
