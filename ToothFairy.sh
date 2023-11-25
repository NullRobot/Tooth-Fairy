#!/bin/bash
# https://github.com/NullRobot/Tooth-Fairy/
# Tooth-Fairy is designed to analyze and summarize data from various sources including HTML and PHP files, websites, and network capture files (pcap and pcapng). It extracts and reports on specific information such as comments, links, cookies, headers, and reflected values from web files or mirrored websites. Additionally, it processes network capture files to extract strings, credentials, and sensitive information, and provides summaries of TCP/UDP streams and overall activities within the capture files.

# Function to check if tshark is installed
check_tshark_installed() {
    if ! command -v tshark &> /dev/null; then
        echo "tshark could not be found, please install it to process capture files."
        exit 1
    fi
}

# Function to check if wget is installed
check_wget_installed() {
    if ! command -v wget &> /dev/null; then
        echo "wget could not be found, please install it to process URLs."
        exit 1
    fi
}

# Function to extract information from HTML/PHP files or webpages
extract_web_info() {
    local file="$1"
    echo "Extracting information from $file..."
    # Comments
    grep -o '<!--.*?-->' "$file" || true
    # Links
    grep -o 'href="[^"]+"' "$file" || true
    # Cookies
    grep -o 'Set-Cookie: [^;]+' "$file" || true
    # Headers
    grep -o '^.*: .*' "$file" || true
    # Reflected values (basic example)
    grep -o '\?[^=]+=[^&]+' "$file" || true
}

# Function to provide a basic summary of web pages
summarize_web_pages() {
    local file="$1"
    echo "Summarizing web page $file..."
    # Count of comments
    echo "Number of comments: $(grep -c '<!--' "$file" || echo "0")"
    # Count of links
    echo "Number of links: $(grep -c 'href=' "$file" || echo "0")"
}

# Function to process pcapng or pcap files
process_pcap_file() {
    local pcap_file="$1"
    check_tshark_installed
    echo "Processing capture file $pcap_file..."
    
    # Define a function to extract strings with at least 9 characters
    extract_strings() {
        local file="$1"
        echo "Extracting strings from $file with at least 9 characters..."
        strings "$file" | awk 'length($0) > 8'
    }
    # Define a function to extract credentials for clear text protocols
    extract_credentials() {
        local file="$1"
        echo "Searching for credentials in $file for clear text protocols..."
        # HTTP Basic Auth
        tshark -r "$file" -Y "http.authorization" -T fields -e http.authorization
        # FTP
        tshark -r "$file" -Y "ftp.request.command == USER || ftp.request.command == PASS" -T fields -e ftp.request.arg
        # Telnet
        tshark -r "$file" -Y "telnet.option_text" -T fields -e telnet.option_text
        # POP3
        tshark -r "$file" -Y "pop.request.command == USER || pop.request.command == PASS" -T fields -e pop.request.arg
        # HTTP POST Form Data
        tshark -r "$file" -Y "http.request.method == POST" -T fields -e http.file_data
        # IRC (assuming USER and PASS commands)
        tshark -r "$file" -Y "irc.request.command == USER || irc.request.command == PASS" -T fields -e irc.request
        # SNMP (community string as a form of credential)
        tshark -r "$file" -Y "snmp.community" -T fields -e snmp.community
        # TFTP (no authentication, but file names could be sensitive)
        tshark -r "$file" -Y "tftp.option" -T fields -e tftp.option
    }
    # Define a function to summarize each TCP/UDP stream
    summarize_streams() {
        local file="$1"
        echo "Summarizing TCP/UDP streams in $file..."
        tshark -r "$file" -q -z conv,tcp
        tshark -r "$file" -q -z conv,udp
    }
    # Define a function to summarize the pcapng file
    summarize_pcapng() {
        local file="$1"
        echo "Summarizing the activities in $file..."
        tshark -r "$file" -q -z io,phs
    }
    # Define a function to search for sensitive information like SSNs, emails, driver's licenses, and passport numbers
    search_sensitive_info() {
        local file="$1"
        echo "Searching for sensitive information in $file..."
        # Social Security numbers (format: XXX-XX-XXXX)
        tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[0-9]{3}-[0-9]{2}-[0-9]{4}'
        # Email addresses
        tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}'
        # Driver license numbers (format varies by state, simple regex example)
        tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{5,9}'
        # Passport numbers (format varies by country, simple regex example)
        tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{6,9}'
    }
    # Call the functions with the pcap file
    extract_strings "$pcap_file"
    extract_credentials "$pcap_file"
    summarize_streams "$pcap_file"
    summarize_pcapng "$pcap_file"
    search_sensitive_info "$pcap_file"
}

# Check if a file path or URL is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_file_or_URL>"
    exit 1
fi

# Assign the first argument as the input
INPUT="$1"

# Check if the input is a URL
if [[ "$INPUT" =~ ^https?:// ]]; then
    check_wget_installed
    echo "Mirroring website $INPUT..."
    wget -mk "$INPUT"
    # Assuming wget creates a directory with the domain name
    DOMAIN=$(echo "$INPUT" | awk -F/ '{print $3}')
    if [ -d "$DOMAIN" ]; then
        for file in $(find "$DOMAIN" -type f); do
            extract_web_info "$file"
            summarize_web_pages "$file"
        done
    else
        echo "Failed to mirror website: $DOMAIN"
        exit 1
    fi
else
    # Check if the file exists
    if [ ! -f "$INPUT" ]; then
        echo "File not found: $INPUT"
        exit 1
    fi

    # Check file type and process accordingly
    FILE_TYPE=$(file --brief --mime-type "$INPUT")
    case "$FILE_TYPE" in
        text/html|application/x-php)
            extract_web_info "$INPUT"
            summarize_web_pages "$INPUT"
            ;;
        application/vnd.tcpdump.pcap|application/x-pcapng|application/octet-stream)
            process_pcap_file "$INPUT"
            ;;
        *)
            echo "Unsupported file type: $FILE_TYPE"
            exit 1
            ;;
    esac
fi
