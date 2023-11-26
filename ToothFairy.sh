#!/bin/bash

# ToothFairy.sh is designed to summarize and analyze data for interesting info from various sources including network capture files (pcap, pcapng, cap, snoop, netmon, etc.). HTML and PHP files, and websites.

cat << "EOF"
                                  ▄
                                ╓██▄╗▀▀▀╬╬╬╬╬╬▀▀▀▀≡╗▄_   ╒█▌
                               ▐█▓██╬╣╬▄───└└└╙╙╙╙▀╝╣╬╬W╓███
                               █╬▓███▄▓▓██▓▓▓▓▓▓▓╩╝╬██▓██M
                              ,████▀▀▀╙╙╙╙╙╙╙╙╠╠╠▀▀▀██▓╣▓▓██M
                            ▄██▀       _.=░░░░░░░░░µ╙▀█▓▓███_
                          ,██"     "Y*▄▄▄▄▄▓▓▓▓▀▀ÑÉ»░░░╠▀██▀█▌
                          ██      `'ⁿª*╝╝╝╨╜╙^``    `'Ü░░░]Ü░██
           ,▄▓▓█▀▀▌      ▓█                            Ü░░░░ÜÉ█▌
       ╔▓█▓▀ÑÑ░▒░░█      █▌   ▄▓███▌_           _▄▄▄▄_ '░░░░Ü▒▓█
        █╣▒░░░░ñ██▒█    ▐█M      ,╠██▄       _▄███▀╙└└└  |░░░ÜÜ╟█M
        ╟█▓ñ█▀Ü░░░░╫w   ▐█⌐     ██████▄  , ▄▓██████▓    |░░░▒Ü░█▌
         █╬▌░░▐▀▀▄▄▓██▓▄▐█M    ▐█▄▐███▒  ╙████ ╫████▌   |░░░Ü▒¢█▌   ,▄▄▄▄▓▄▄,
         ▐█▓▄▄▓▓██▓██▓██ █▌     ██████Ü     ██▄█████▌   |░░░ÜÜ╟█▓▓█▀▀╙└¬ __└▀█
         ╟███▓██████████ ██      ▀███▀^     ╙██████▀    |░░░ÜÜ▓█Ñ»,-»»░»»»»»»╟▌
          █▀"_,▓██████▓█ ▓█         ²▌        ─┘▄▄▄▄-   ░░░ÜÜÜ██░»»»»»»»»»»»»╫▌
         ╟▌▄▀╙╓╓▄██████╣▌▐█▌       ▐▌W≈╤≡≡**M▀╙T▓▀     ▒▒▒▒#▄▓█Ñ░»»»»»»»»»»»,█
          █M▄▀╙└,╔█████▓█ ██       '█N..___..─φ▓"      ╠▒¼▒▒▒╬▀█▌_»»»»»»»»»╓█M
          ╙█▌,▓▀╙▄▓█████╣▓╣█▄      ⁿ▀▄▄____,▄A╙        [ÜÅ▓█╬▓▒▒╬█▄»»»»»»_▓█
            ▀█╓╔██████████▒██         -─,,             ÜÜÜÜ▓██╬▓▒╬█∩»»»▄▓█╙
             ╙▀███████▓██████▄                        |ÜÜÜ░██╠██▀▀▀▀▓▓▀▀
                └╙██╬█▓▀    ██       ,▒Ü▀▓,           ╚ÜÜÜ╫█▒╫▓═¬¬  ╙▀▄
                   '╙"      '█▌     |▒▒▒▒╬█▌         |ÜÜÜ░██▀█       _█
                             ╟█⌐    ▒▒▒▒Ü████        ÜÜÜÜ▓█  █Ä░,__.,╟█
                              ██   |ÜÜ▒▒▓█  ██      ╚Ü▒Ü▐█▀  ╙▓▓▓▓▄▓▓▀
                               ██  |Ü▒Ü║█▌   █▌    ╔ÜÜÜ¼█▌
                                ██ 'Ü▒Ü██    ╙█▄  |ÜÜÜ¼██
                                 ██▄[Ü▐█▌     ╫█ /ÜÜÜ▄█▀
                                  ╙██▒▓█,,,,,,,██░Ü▄██Γ
                        _╓╔╦╦▒▒ÜÜÜÜ╬██▌ÜÜÜÜÜÜ▒Ö████Ñ░ÜÜ▒▒▒╦╦╦╓_
                       ╩ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÉ▀ÑÜÜÜÜÜ▒ÜÜÜ▒ÜÜÜ╠
                         ``╙╙╚╚╩Ü▒ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ▒Ü╩╩╚╙╙^`
EOF
sleep 1

# Function to print a table header
print_table_header() {
    local header="$1"
    printf "+%*s+\n" $(( (${#header} + 2) )) ""
    printf "| %s |\n" "$header"
    printf "+%*s+\n" $(( (${#header} + 2) )) ""
}

# Function to check if tshark is installed
check_tshark_installed() {
    if ! command -v tshark &> /dev/null; then
        print_table_header "tshark could not be found, please install it to process capture files."
        exit 1
    fi
}

# Function to check if wget is installed
check_wget_installed() {
    if ! command -v wget &> /dev/null; then
        print_table_header "wget could not be found, please install it to process URLs."
        exit 1
    fi
}

# Function to extract information from HTML/PHP/TXT files or webpages
extract_web_info() {
    local file="$1"
    print_table_header "Extracting information from $file"
    sleep 1
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
    print_table_header "Summarizing web page $file"
    sleep 1
    # Count of comments
    echo "Number of comments: $(grep -c '<!--' "$file" || echo "0")"
    # Count of links
    echo "Number of links: $(grep -c 'href=' "$file" || echo "0")"
}

# Function to process pcapng or pcap files
process_pcap_file() {
    local pcap_file="$1"
    check_tshark_installed
    print_table_header "Processing capture file $pcap_file"
    sleep 1
    # Define a function to extract strings with at least 9 characters
    extract_strings() {
        local file="$1"
        print_table_header "Extracting strings from $file with at least 9 characters"
	sleep 1
        strings "$file" | awk 'length($0) > 8'
    }
    # Function to extract credentials for clear text protocols
extract_credentials() {
    local file="$1"
    print_table_header "Searching for credentials in $file for clear text protocols"
    sleep 1
    # Function to convert hex to ASCII
    hex_to_ascii() {
        echo "$1" | xxd -r -p
    }
    # HTTP Basic Auth
    tshark -r "$file" -Y "http.authorization" -T fields -e http.authorization 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # FTP
    tshark -r "$file" -Y "ftp.request.command == USER || ftp.request.command == PASS" -T fields -e ftp.request.arg 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # Telnet
    tshark -r "$file" -Y "telnet.data" -T fields -e telnet.data 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # POP3
    tshark -r "$file" -Y "pop.request.command == USER || pop.request.command == PASS" -T fields -e pop.request.arg 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # HTTP POST Form Data
    tshark -r "$file" -Y "http.request.method == POST" -T fields -e http.file_data 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # IRC (assuming USER and PASS commands)
    tshark -r "$file" -Y "irc.request.command == USER || irc.request.command == PASS" -T fields -e irc.request 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # SNMP (community string as a form of credential)
    tshark -r "$file" -Y "snmp.community" -T fields -e snmp.community 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
    # TFTP (no authentication, but file names could be sensitive)
    tshark -r "$file" -Y "tftp.option" -T fields -e tftp.option 2>/dev/null | while read -r line; do
        if [[ "$line" =~ ^[0-9A-Fa-f]+$ ]]; then
            hex_to_ascii "$line"
        else
            echo "$line"
        fi
    done
}

    # Define a function to summarize each TCP/UDP stream
    summarize_streams() {
        local file="$1"
        print_table_header "Summarizing TCP/UDP streams in $file"
	sleep 1
        tshark -r "$file" -q -z conv,tcp
        tshark -r "$file" -q -z conv,udp
    }
    # Define a function to summarize the pcapng file
    summarize_pcapng() {
        local file="$1"
        print_table_header "Summarizing the activities in $file"
	sleep 1
        tshark -r "$file" -q -z io,phs
    }
    # Define a function to search for sensitive information that is useful to see in Network capture files. ( SSNs, emails, driver's licenses, passport numbers, phone numbers, credit card numbers, usernames, passwords, domain names, file names, geolocation data, hostnames, IP addresses, MAC addresses, metadata, network shares, operating systems, ports, protocols, queries, registry data, services, version numbers, web requests, zip codes.
    search_sensitive_info() {
    local file="$1"
    print_table_header "Searching for possible sensitive information in $file"
    sleep 1
    # Social Security numbers (format: XXX-XX-XXXX)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[0-9]{3}-[0-9]{2}-[0-9]{4}' | sort | uniq | while read -r ssn; do
        echo "SSN: $ssn"
    done 2>/dev/null
    # Email addresses
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}' | sort | uniq | while read -r email; do
        echo "Email: $email"
    done 2>/dev/null
    # Driver license numbers (format varies by state, simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{5,9}' | sort | uniq | while read -r dl; do
        echo "Driver's License: $dl"
    done 2>/dev/null
    # Passport numbers (format varies by country, simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '[A-Z0-9]{6,9}' | sort | uniq | while read -r passport; do
        echo "Passport: $passport"
    done 2>/dev/null
    # Phone numbers (format: XXX-XXX-XXXX)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b[0-9]{3}-[0-9]{3}-[0-9]{4}\b' | sort | uniq | while read -r phone; do
        echo "Phone: $phone"
    done 2>/dev/null
    # Credit card numbers (format: XXXX-XXXX-XXXX-XXXX)
    # Visa
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b4[0-9]{3}-[0-9]{4}-[0-9]{4}-[0-9]{4}\b' | sort | uniq | while read -r visa; do
        echo "Visa: $visa"
    done 2>/dev/null
    # MasterCard
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b5[1-5][0-9]{2}-[0-9]{4}-[0-9]{4}-[0-9]{4}\b' | sort | uniq | while read -r mastercard; do 
        echo "MasterCard: $mastercard"
    done 2>/dev/null
    # American Express
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b3[47][0-9]{2}-[0-9]{6}-[0-9]{5}\b' | sort | uniq | while read -r amex; do
        echo "American Express: $amex"
    done 2>/dev/null
    # Discover
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b6(?:011|5[0-9]{2})-[0-9]{4}-[0-9]{4}-[0-9]{4}\b' | sort | uniq | while read -r discover; do
        echo "Discover: $discover"
    done 2>/dev/null
    # Diners Club
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b3(?:0[0-5]|[68][0-9])[0-9]{4}-[0-9]{4}-[0-9]{4}\b' | sort | uniq | while read -r diners; do
        echo "Diners Club: $diners"
    done 2>/dev/null
    # JCB
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b(?:2131|1800|35\d{3})\d{11}\b' | sort | uniq | while read -r jcb; do
        echo "JCB: $jcb"
    done 2>/dev/null
    # Usernames (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\buser(name)?[=:][^&\s]+' | sort | uniq | while read -r username; do
        echo "Username: $username"
    done 2>/dev/null
    # Passwords (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\bpass(word)?[=:][^&\s]+' | sort | uniq | while read -r password; do
        echo "Password: $password"
    done 2>/dev/null
    # Domain names
    tshark -r "$file" -Y "dns.qry.name" -T fields -e dns.qry.name | sort | uniq | while read -r domain; do
        echo "Domain: $domain"
    done 2>/dev/null
    # File names
    tshark -r "$file" -Y "smb2.filename" -T fields -e smb2.filename | sort | uniq | while read -r filename; do
        echo "File Name: $filename"
    done 2>/dev/null
    # Geolocation data (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE 'lat(itude)?[=:][^&\s]+' | sort | uniq | while read -r latitude; do
        echo "Latitude: $latitude"
    done 2>/dev/null
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE 'lon(gitude)?[=:][^&\s]+' | sort | uniq | while read -r longitude; do
        echo "Longitude: $longitude"
    done 2>/dev/null
    # Hostnames
    tshark -r "$file" -Y "http.host" -T fields -e http.host | sort | uniq | while read -r hostname; do
        echo "Hostname: $hostname"
    done 2>/dev/null
    # IP addresses
    tshark -r "$file" -Y "ip.addr" -T fields -e ip.addr | sort | uniq | while read -r ip; do
        echo "IP Address: $ip"
    done 2>/dev/null
    # MAC addresses
    tshark -r "$file" -Y "eth.addr" -T fields -e eth.addr | sort | uniq | while read -r mac; do
        echo "MAC Address: $mac"
    done 2>/dev/null
    # Metadata (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE 'meta(data)?[=:][^&\s]+' | sort | uniq | while read -r metadata; do
        echo "Metadata: $metadata"
    done 2>/dev/null
    # Network shares
    tshark -r "$file" -Y "smb.path" -T fields -e smb.path | sort | uniq | while read -r share; do
        echo "Network Share: $share"
    done 2>/dev/null
    # Operating systems (simple regex example)
    tshark -r "$file" -Y "http.user_agent" -T fields -e http.user_agent | grep -oE 'Windows|Macintosh|Linux' | sort | uniq | while read -r os; do
        echo "Operating System: $os"
    done 2>/dev/null
    # Ports
    tshark -r "$file" -Y "tcp.port" -T fields -e tcp.port | sort | uniq | while read -r port; do
        echo "Port: $port"
    done 2>/dev/null
    # Protocols
    tshark -r "$file" -Y "frame.protocols" -T fields -e frame.protocols | sort | uniq | while read -r protocol; do
        echo "Protocol: $protocol"
    done 2>/dev/null
    # Queries
    tshark -r "$file" -Y "http.request.uri" -T fields -e http.request.uri | sort | uniq | while read -r query; do
        echo "Query: $query"
    done 2>/dev/null
    # Registry data (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE 'registry[=:][^&\s]+' | sort | uniq | while read -r registry; do
        echo "Registry Data: $registry"
    done 2>/dev/null
    # Services
    tshark -r "$file" -Y "smb.service" -T fields -e smb.service | sort | uniq | while read -r service; do
        echo "Service: $service"
    done 2>/dev/null
    # Version numbers
    tshark -r "$file" -Y "http.server" -T fields -e http.server | sort | uniq | while read -r version; do
        echo "Version: $version"
    done 2>/dev/null
    # Web requests
    tshark -r "$file" -Y "http.request.full_uri" -T fields -e http.request.full_uri | sort | uniq | while read -r webrequest; do
        echo "Web Request: $webrequest"
    done 2>/dev/null
    # Zip codes (simple regex example)
    tshark -r "$file" -Y "data.data" -T fields -e data.data | grep -oE '\b[0-9]{5}(-[0-9]{4})?\b' | sort | uniq | while read -r zipcode; do
        echo "Zip Code: $zipcode"
    done 2>/dev/null
}
    # Call the functions with the pcap file
    extract_credentials "$pcap_file"
    extract_strings "$pcap_file"
    summarize_streams "$pcap_file"
    summarize_pcapng "$pcap_file"
    search_sensitive_info "$pcap_file"
} 

# Check if a file path or URL is provided
if [ "$#" -ne 1 ]; then
    print_table_header "Usage: $0 <path_to_file_or_URL>"
    exit 1
fi

# Assign the first argument as the input
INPUT="$1"

# Check if the input is a URL
if [[ "$INPUT" =~ ^https?:// ]]; then
    check_wget_installed	
    print_table_header "Mirroring website $INPUT"
    wget -mk "$INPUT"
    # Assuming wget creates a directory with the domain name
    DOMAIN=$(echo "$INPUT" | awk -F/ '{print $3}')
    if [ -d "$DOMAIN" ]; then
        for file in $(find "$DOMAIN" -type f); do
            extract_web_info "$file"
            summarize_web_pages "$file"
        done
    else
        print_table_header "Failed to mirror website: $DOMAIN"
        exit 1
    fi
else
    # Check if the file exists
    if [ ! -f "$INPUT" ]; then
        print_table_header "File not found: $INPUT"
        exit 1
    fi

    # Check file type and process accordingly
    FILE_TYPE=$(file --brief --mime-type "$INPUT")
    case "$FILE_TYPE" in
        text/html|application/x-php|text/plain)
            extract_web_info "$INPUT"
            summarize_web_pages "$INPUT"
            ;;
        application/vnd.tcpdump.pcap|application/x-pcapng|application/octet-stream)
            process_pcap_file "$INPUT"
            ;;
        *)
            print_table_header "Unsupported file type: $FILE_TYPE"
            exit 1
            ;;
    esac
fi

