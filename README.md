# Tooth Fairy
![Tooth-Fairy](https://github.com/NullRobot/Tooth-Fairy/assets/58863699/12b0c5d2-db07-4c6a-9275-f0f4048a46c7)

**ToothFairy.sh** is a versatile tool designed to analyze and summarize data from network capture files and web content. For network captures, the script can extract and search for sensitive information such as email addresses, credit card numbers, passwords, file names, geolocation data, network shares, and more. ToothFairy.sh supports a variety of formats including pcap, pcapng, cap, snoop, netmon, and others. 

For web content, it extracts information such as robots.txt, comments, links, cookies, and headers, and provides a summary of web pages. It accepts all textual file formats commonly used for websites, including HTML, PHP, CSS, JS, and TXT files. 

# Dependencies:
The script requires the installation of **tshark** to process network capture files.

_Note:_ ToothFairy.sh uses common tools included on most Unix-like systems (wget, grep, awk, strings, & file). These tools should be readily available on Linux, Unix, and Mac OS.

# Instructions for Network Capture Features:
1. The script can process network capture files to extract strings, credentials for clear text protocols, and summarize TCP/UDP streams.
2. It searches for sensitive information such as Social Security numbers, email addresses, driver's licenses, passport numbers, phone numbers, credit card numbers, usernames, passwords, domain names, file names, geolocation data, hostnames, IP addresses, MAC addresses, metadata, network shares, operating systems, ports, protocols, queries, registry data, services, version numbers, web requests, and zip codes.

# Instructions for Web Page and Website Features:
1. For web pages and websites, the script can mirror a website using wget and analyze the downloaded content.
2. It extracts comments, links, cookies, and headers from HTML, PHP, and TXT files.
3. It provides a summary of web pages, including the count of comments and links.

# How to Run the Script:
1. Save the script as "ToothFairy.sh" on your system.
2. Make the script executable by running the command: `chmod +x ToothFairy.sh`
3. Execute the script by providing a path to a file or a URL as an argument: `./ToothFairy.sh <path_to_file_or_URL>`

# How to Install tshark:

**On Linux:**
- Use your package manager to install tshark. For example, on Debian-based systems, use: `sudo apt-get install tshark`

**On Mac OS:**
- Install Homebrew if it's not already installed: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install tshark using Homebrew: `brew install wireshark`

**On Unix:**
- Use the package management tools available for your specific Unix variant to install tshark. For example, on FreeBSD, use: `pkg install wireshark`

Ensure you have the necessary permissions to install software on your system and that you may need to use `sudo` to install packages.
