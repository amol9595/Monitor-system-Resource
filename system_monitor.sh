#!/bin/bash

# Function to display CPU usage
cpu_usage() {
    echo "CPU Usage:"
    top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU: " $2 + $4 "%"}'
    echo ""
}

# Function to display Memory usage
memory_usage() {
    echo "Memory Usage:"
    free -h | awk 'NR==2{printf "Memory: %s/%s (%.2f%%)\n", $3,$2,$3*100/$2 }'
    echo ""
}

# Function to display Disk usage
disk_usage() {
    echo "Disk Usage:"
    df -h | grep '^/dev/' | awk '{print $1 ": " $5 " used (" $3 "/" $2 ")"}'
    echo ""
}

# Function to display Network stats
network_stats() {
    echo "Network Stats:"
    ip -s link | awk '/^[0-9]+:/{print $2} /RX:/{getline; print "  RX: " $1 " bytes"} /TX:/{getline; print "  TX: " $1 " bytes"}'
    echo ""
}

# Function to display system uptime
system_uptime() {
    echo "System Uptime:"
    uptime -p
    echo ""
}

# Function to display I/O stats
io_stats() {
    echo "I/O Stats:"
    iostat -dx | awk 'NR==3{print "Device\t\tTps\t\tkB_read/s\tkB_wrtn/s"} NR>3{print $1 "\t\t" $2 "\t\t" $3 "\t\t" $4}'
    echo ""
}

# Function to show the full dashboard
dashboard() {
    clear
    echo "System Monitoring Dashboard"
    echo "---------------------------"
    cpu_usage
    memory_usage
    disk_usage
    network_stats
    system_uptime
    io_stats
}

# Usage function to explain command-line options
usage() {
    echo "Usage: $0 [-c] [-m] [-d] [-n] [-u] [-i] [-h]"
    echo "  -c   Show CPU usage"
