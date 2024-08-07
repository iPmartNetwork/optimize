#!/bin/bash

# Color codes
Purple='\033[0;35m'
Cyan='\033[0;36m'
cyan='\033[0;36m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
White='\033[0;96m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color 

# Check if the user has root access
if [ "$EUID" -ne 0 ]; then
  echo $'\e[32mPlease run with root privileges.\e[0m'
  exit
fi


    echo -e "${Purple}"
    cat << "EOF"
          
                 
══════════════════════════════════════════════════════════════════════════════════════
        ____                             _     _                                     
    ,   /    )                           /|   /                                  /   
-------/____/---_--_----__---)__--_/_---/-| -/-----__--_/_-----------__---)__---/-__-
  /   /        / /  ) /   ) /   ) /    /  | /    /___) /   | /| /  /   ) /   ) /(    
_/___/________/_/__/_(___(_/_____(_ __/___|/____(___ _(_ __|/_|/__(___/_/_____/___\__

══════════════════════════════════════════════════════════════════════════════════════
EOF
    echo -e "${NC}"

# Function to install necessary tools
install_tools() {
    echo "Installing necessary tools..."
    sudo apt-get update
    sudo apt-get install -y iproute2
    echo "Tools installed."
}

# Function to optimize network settings
optimize_network() {
    echo "Applying network optimizations..."

    # Set up QDisc for reducing jitter
    sudo tc qdisc add dev eth0 root fq

    # Set TCP BBR as the congestion control algorithm
    sudo sysctl -w net.ipv4.tcp_congestion_control=bbr

    # Increase network buffer sizes
    sudo sysctl -w net.core.rmem_max=16777216
    sudo sysctl -w net.core.wmem_max=16777216
    sudo sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216"

    # Enable TCP Fast Open
    sudo sysctl -w net.ipv4.tcp_fastopen=3

    # Apply changes
    sudo sysctl -p

    echo "Network optimizations applied."
}

# Function to check network status
check_network_status() {
    echo "Checking network status..."
    echo "Current congestion control algorithm: $(sysctl net.ipv4.tcp_congestion_control)"
    echo "Current rmem_max: $(sysctl net.core.rmem_max)"
    echo "Current wmem_max: $(sysctl net.core.wmem_max)"
    echo "Current TCP rmem: $(sysctl net.ipv4.tcp_rmem)"
    echo "Current TCP wmem: $(sysctl net.ipv4.tcp_wmem)"
    echo "Current TCP fast open: $(sysctl net.ipv4.tcp_fastopen)"
}

# Main script
install_tools
optimize_network
check_network_status

echo "Server optimization completed successfully."
