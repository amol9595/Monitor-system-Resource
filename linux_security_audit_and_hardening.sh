#!/bin/bash

# Ensure the script is run as root
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root. Exiting..."
    exit 1
fi

# Function to update and upgrade the system
update_system() {
    echo "[INFO] Updating the system and installing security patches..."
    if command -v apt &>/dev/null; then
        apt update && apt upgrade -y
    elif command -v yum &>/dev/null; then
        yum update -y
    fi
}

# Function to disable root login via SSH
disable_root_ssh() {
    echo "[INFO] Disabling root login via SSH..."
    sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    systemctl reload sshd
}

# Function to configure password complexity
configure_password_complexity() {
    echo "[INFO] Configuring password complexity..."
    if ! grep -q pam_pwquality.so /etc/pam.d/common-password; then
        echo "password requisite pam_pwquality.so retry=3 minlen=8" >> /etc/pam.d/common-password
    fi
}

# Function to configure automatic updates
setup_auto_updates() {
    echo "[INFO] Configuring automatic security updates..."
    if command -v apt &>/dev/null; then
        apt install unattended-upgrades -y
        dpkg-reconfigure --priority=low unattended-upgrades
    elif command -v yum &>/dev/null; then
        yum install yum-cron -y
        systemctl enable yum-cron
        systemctl start yum-cron
    fi
}

# Function to configure UFW/Firewalld
setup_firewall() {
    echo "[INFO] Setting up firewall rules..."
    if command -v ufw &>/dev/null; then
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        ufw enable
    elif command -v firewall-cmd &>/dev/null; then
        firewall-cmd --permanent --set-default-zone=public
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --reload
    fi
}

# Function to check for world-writable files
check_world_writable_files() {
    echo "[INFO] Checking for world-writable files..."
    find / -xdev -type d \( -perm -0002 -a ! -perm -1000 \) -print
}

# Function to disable unnecessary services
disable_unused_services() {
    echo "[INFO] Disabling unnecessary services..."
    systemctl disable avahi-daemon 2>/dev/null
    systemctl disable cups 2>/dev/null
    systemctl disable bluetooth 2>/dev/null
}

# Function to audit IPv4/IPv6 configurations
check_ip_configurations() {
    echo "[INFO] Checking IPv4 and IPv6 configurations..."
    echo "[IPv4]"
    ip -4 a
    echo "[IPv6]"
    ip -6 a
}

# Function to check for public vs private IP addresses
check_public_private_ip() {
    echo "[INFO] Checking for public vs private IP addresses..."
    ip -4 addr show | grep -Eo 'inet [0-9.]+/[0-9]+' | awk '{print $2}' | while read -r ip; do
        if [[ $ip =~ ^10\. ]] || [[ $ip =~ ^172\.1[6-9]\. ]] || [[ $ip =~ ^192\.168\. ]]; then
            echo "Private IP found: $ip"
        else
            echo "Public IP found: $ip"
        fi
    done
}

# Function to audit installed packages for vulnerabilities
audit_installed_packages() {
    echo "[INFO] Auditing installed packages for vulnerabilities..."
    if command -v apt &>/dev/null; then
        apt install debsums -y
        debsums -s
    elif command -v yum &>/dev/null; then
        yum install yum-plugin-security -y
        yum updateinfo list security all
    fi
}

# Main function to call the audit and hardening procedures
main() {
    echo "[INFO] Starting security audit and hardening process..."
    update_system
    disable_root_ssh
    configure_password_complexity
    setup_auto_updates
    setup_firewall
    disable_unused_services
    check_ip_configurations
    check_public_private_ip
    check_world_writable_files
    audit_installed_packages
    echo "[INFO] Security audit and hardening completed!"
}

main
