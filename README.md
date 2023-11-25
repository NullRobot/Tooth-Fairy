# Tooth Fairy
![Tooth-Fairy](https://github.com/NullRobot/Tooth-Fairy/assets/58863699/12b0c5d2-db07-4c6a-9275-f0f4048a46c7)

**ToothFairy.sh** is designed to summarize and analyze data for interesting info from various sources including network capture files (pcap, pcapng, cap, snoop, netmon, etc.). HTML and PHP files, and websites. It processes network capture files to extract strings, credentials, and sensitive information and provides summaries of TCP/UDP streams and overall activities within the capture files. Additionally, it extracts and reports on specific information such as comments, links, cookies, headers, and reflected values from web files or mirrored websites.  

# Dependencies:
- tshark: A network protocol analyzer used for capturing and displaying the contents of network packets.

Note: The script uses common tools included on most Unix-like systems (wget, grep, awk, strings, & file) These tools should be readily available on Linux, Unix, and Mac OS. 

# Instructions to Run the Script:
1. Save the script to a file, for example, `ToothFairy.sh`.
2. Make the script executable by running the command `chmod +x analyze.sh`.
3. Execute the script by running `./ToothFairy.sh <path_to_file_or_URL>`, replacing `<path_to_file_or_URL>` with the actual path to the HTML/PHP file or the URL of the website you want to analyze, or the path to the pcap/pcapng file you want to process.

**How to Install tshark:**
- macOS:
  1. Open the Terminal.
  2. Install Homebrew if it is not already installed, using the command `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`.
  3. Install tshark using Homebrew with the command `brew install wireshark`.

- Linux (Debian-based systems):
  1. Open the Terminal.
  2. Update the package list with `sudo apt-get update`.
  3. Install tshark using the command `sudo apt-get install tshark`.

- Unix:
  The installation method for tshark on Unix systems varies depending on the specific version and distribution of Unix. Generally, you can use the system's package manager (such as pkg_add on OpenBSD, pkg on FreeBSD, or the appropriate package manager for your Unix variant) to install tshark. If a package manager is unavailable, you may need to build tshark from source.
