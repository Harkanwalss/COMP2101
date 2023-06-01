#!/bin/bash

# Display the fully-qualified domain name (FQDN)
fqdn=$(hostname)
echo "Fully-Qualified Domain Name (FQDN): $fqdn"

# Display the operating system name and version
os_info=$(hostnamectl | grep "Operating System")
echo "Operating System: $os_info"

# Display the IP addresses of the machine (excluding 127.0.0.1)
ip_addresses=$(hostname -I | awk '{gsub(/^127\./, ""); print}')
echo "IP Addresses: $ip_addresses"

# Display the available space in the root filesystem
space_info=$(df -h / | awk 'NR==2{print $4}')
echo "Available Space in Root Filesystem: $space_info"
