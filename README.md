# Wireless-Security-Toolkit
Menu-driven automation for wireless pentesting workflows

A small, menu-driven Bash wrapper around selected tools from the aircrack-ng suite to help automate common wireless lab tasks (monitor mode management, passive capture, injection tests, and cracking in a controlled environment).

Features:
Start/stop monitor mode (airmon-ng)
Live capture / targeted capture with airodump-ng
Injection test and fake authentication (aireplay-ng)
WEP / WPA dictionary cracking (aircrack-ng)
Simple interactive menu with input validation
Root-check and safe-usage reminders

Requirements / Dependencies
You need a Linux environment with the aircrack-ng suite installed. Recommended platforms: Kali Linux, Debian/Ubuntu with aircrack-ng package, or any Linux distro with wireless tools and proper drivers.
bash shell
aircrack-ng (includes airmon-ng, airodump-ng, aireplay-ng, aircrack-ng)
Run the script as root (or via sudo) because wireless mode changes and packet injection require elevated privileges.

Quickstart — run the script

Make the script executable:
chmod +x wireless-toolkit.sh

Run as root:
sudo ./wireless-toolkit.sh

Use the interactive menu:
Choose 1 to manage monitor mode (start/stop/check kill).
Choose 2 to run airodump-ng (live view or targeted capture).
Choose 3 to run aireplay-ng tests (injection/fake auth/custom).
Choose 4 to run aircrack-ng (WEP or dictionary-based WPA cracking).
Choose 0 to exit.
