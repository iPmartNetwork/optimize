#!/bin/bash

# Function to install necessary tools
install_tools() {
    echo "Installing necessary tools..."
    sudo apt-get update
    sudo apt-get install -y iproute2 net-tools curl
    echo "Tools installed."
}

# Function to optimize network settings
optimize_network() {
    echo "Applying network optimizations..."

    # Set up QDisc for reducing jitter
    sudo tc qdisc add dev eth0 root fq

    # Set TCP BBR as the congestion control algorithm
    sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
    sudo sysctl -w net.ipv6.tcp_congestion_control=bbr

    # Increase network buffer sizes
    sudo sysctl -w net.core.rmem_max=16777216
    sudo sysctl -w net.core.wmem_max=16777216
    sudo sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216"
    sudo sysctl -w net.ipv6.tcp_rmem="4096 87380 16777216"
    sudo sysctl -w net.ipv6.tcp_wmem="4096 65536 16777216"

    # Enable TCP Fast Open
    sudo sysctl -w net.ipv4.tcp_fastopen=3
    sudo sysctl -w net.ipv6.tcp_fastopen=3

    # Disable TCP timestamps to reduce latency
    sudo sysctl -w net.ipv4.tcp_timestamps=0
    sudo sysctl -w net.ipv6.tcp_timestamps=0

    # Apply changes
    sudo sysctl -p

    echo "Network optimizations applied."
}

# Function to check network status
check_network_status() {
    echo "Checking network status..."
    echo "Current congestion control algorithm (IPv4): $(sysctl net.ipv4.tcp_congestion_control)"
    echo "Current congestion control algorithm (IPv6): $(sysctl net.ipv6.tcp_congestion_control)"
    echo "Current rmem_max: $(sysctl net.core.rmem_max)"
    echo "Current wmem_max: $(sysctl net.core.wmem_max)"
    echo "Current TCP rmem (IPv4): $(sysctl net.ipv4.tcp_rmem)"
    echo "Current TCP wmem (IPv4): $(sysctl net.ipv4.tcp_wmem)"
    echo "Current TCP rmem (IPv6): $(sysctl net.ipv6.tcp_rmem)"
    echo "Current TCP wmem (IPv6): $(sysctl net.ipv6.tcp_wmem)"
    echo "Current TCP fast open (IPv4): $(sysctl net.ipv4.tcp_fastopen)"
    echo "Current TCP fast open (IPv6): $(sysctl net.ipv6.tcp_fastopen)"
    echo "Current TCP timestamps (IPv4): $(sysctl net.ipv4.tcp_timestamps)"
    echo "Current TCP timestamps (IPv6): $(sysctl net.ipv6.tcp_timestamps)"
}

# Function to enable gaming mode
enable_gaming_mode() {
    echo "Enabling gaming mode..."
    sudo sysctl -w net.ipv4.tcp_low_latency=1
    sudo sysctl -w net.ipv6.tcp_low_latency=1
    echo "Gaming mode enabled."
}

# Main script
install_tools
optimize_network
enable_gaming_mode
check_network_status

echo "Server optimization and gaming mode enabled successfully."
