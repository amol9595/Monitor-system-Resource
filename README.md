# Monitor-system-Resource
The system_monitor.sh script is designed to monitor various system resources, providing real-time insights in a dashboard format. The script can be run to display an entire dashboard that refreshes every few seconds or can be used to show individual resource statistics through command-line options.

The system resources monitored include:

CPU usage
Memory usage
Disk usage
Network statistics
System uptime
I/O statistics
Requirements
Ensure that you have the following utilities installed on your system:

top
free
df
ip (from iproute2 package)
uptime
iostat (from sysstat package)

# Linux Security Audit and Hardening Script

## Overview
This script automates security audits and server hardening on Linux servers. It checks for common vulnerabilities, IPv4/IPv6 configurations, public/private IP identification, and applies hardening measures based on best practices.

## Features
- System update and patching
- Disable root login via SSH
- Enforce password complexity
- Setup automatic security updates
- Configure firewall
- Disable unnecessary services
- Check IP configurations and detect public vs. private IP addresses
- Audit installed packages for vulnerabilities

## Usage
### Clone the Repository
```bash
git clone https://github.com/your-username/linux-security-audit.git
cd linux-security-audit
