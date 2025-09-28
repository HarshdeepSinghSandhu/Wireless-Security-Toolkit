#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root (sudo)." >&2
  exit 1
fi

clear
while :; do
  echo "======================================"
  echo "   Wireless Security Toolkit   "
  echo "======================================"
  echo ""
  echo " 0 - Exit"
  echo " 1 - airmon-ng (monitor mode)"
  echo " 2 - airodump-ng (capture / sniff)"
  echo " 3 - aireplay-ng (injection / auth)"
  echo " 4 - aircrack-ng (cracking)"
  echo ""

  read -r -p "Select option (0-4): " sel
  if ! [[ "$sel" =~ ^[0-9]+$ ]]; then
    echo "Invalid selection. Please enter a number 0-4."
    continue
  fi

  if [ "$sel" -eq 0 ]; then
    echo "Exiting. Bye."
    break
  fi

  if [ "$sel" -eq 1 ]; then
    echo ""
    echo "=== airmon-ng (monitor mode management) ==="
    echo " 1 - check and kill interfering processes"
    echo " 2 - start monitor mode"
    echo " 3 - stop monitor mode"
    echo ""
    read -r -p "Select airmon-ng option (1-3): " monitor_action
    if ! [[ "$monitor_action" =~ ^[0-9]+$ ]]; then
      echo "Invalid option."
      continue
    fi

    if [ "$monitor_action" -eq 1 ]; then
      echo "Running: airmon-ng check kill"
      airmon-ng check kill
    elif [ "$monitor_action" -eq 2 ]; then
      read -r -p "Enter wireless interface (e.g. wlan0): " wlan_iface
      echo "Starting monitor on: $wlan_iface"
      airmon-ng start "$wlan_iface"
    elif [ "$monitor_action" -eq 3 ]; then
      read -r -p "Enter monitor interface (e.g. wlan0mon): " monitor_iface
      echo "Stopping monitor on: $monitor_iface"
      airmon-ng stop "$monitor_iface"
    else
      echo "Returning to main menu."
    fi

  elif [ "$sel" -eq 2 ]; then
    echo ""
    echo "=== airodump-ng (sniff / capture) ==="
    echo " 1 - Basic sniffing (live view)"
    echo " 2 - Targeted capture (bssid + channel + write file)"
    echo ""
    read -r -p "Select airodump-ng option (1-2): " airo_action
    if ! [[ "$airo_action" =~ ^[0-9]+$ ]]; then
      echo "Invalid option."
      continue
    fi

    if [ "$airo_action" -eq 1 ]; then
      read -r -p "Enter monitor interface (e.g. wlan0mon): " monitor_iface_live
      echo "Starting airodump-ng on $monitor_iface_live"
      airodump-ng "$monitor_iface_live"
    elif [ "$airo_action" -eq 2 ]; then
      read -r -p "Channel: " capture_channel
      read -r -p "Target BSSID (xx:xx:xx:xx:xx:xx): " target_bssid
      read -r -p "Output filename prefix: " capture_prefix
      read -r -p "Monitor interface (e.g. wlan0mon): " monitor_iface_target
      echo "Starting targeted capture: channel $capture_channel, bssid $target_bssid, file $capture_prefix"
      airodump-ng -c "$capture_channel" --bssid "$target_bssid" -w "$capture_prefix" "$monitor_iface_target"
    else
      echo "Returning to main menu."
    fi

  elif [ "$sel" -eq 3 ]; then
    echo ""
    echo "=== aireplay-ng (injection / fake auth) ==="
    echo " 1 - Injection testing (aireplay-ng -9)"
    echo " 2 - Fake authentication (aireplay-ng -1)"
    echo " 3 - Custom aireplay-ng command (advanced)"
    echo ""
    read -r -p "Select aireplay-ng option (1-3): " aire_action
    if ! [[ "$aire_action" =~ ^[0-9]+$ ]]; then
      echo "Invalid option."
      continue
    fi

    if [ "$aire_action" -eq 1 ]; then
      read -r -p "Monitor interface (e.g. wlan0mon): " monitor_iface_test
      echo "Testing injection on $monitor_iface_test"
      aireplay-ng -9 "$monitor_iface_test"

    elif [ "$aire_action" -eq 2 ]; then
      read -r -p "Target ESSID: " target_essid
      read -r -p "Target BSSID: " target_bssid_auth
      read -r -p "Spoof (source) MAC to use (your MAC): " spoof_mac
      read -r -p "Monitor interface (e.g. wlan0mon): " monitor_iface_auth
      echo "Running fake authentication..."
      aireplay-ng -1 0 -e "$target_essid" -a "$target_bssid_auth" -h "$spoof_mac" "$monitor_iface_auth"

    elif [ "$aire_action" -eq 3 ]; then
      echo "Enter a single-line custom aireplay-ng argument string (no leading tool name)."
      echo "Example: \"-3 -b <BSSID> -h <CLIENT_MAC> wlan0mon\""
      read -r -p "Custom args: " user_args
      echo "Executing: aireplay-ng $user_args"
      aireplay-ng $user_args
    else
      echo "Returning to main menu."
    fi

  elif [ "$sel" -eq 4 ]; then
    echo ""
    echo "=== aircrack-ng (cracking) ==="
    echo " 1 - Attempt WEP crack (requires capture with IVs)"
    echo " 2 - Dictionary attack (WPA/WPA2 handshake)"
    echo ""
    read -r -p "Select aircrack-ng option (1-2): " crack_action
    if ! [[ "$crack_action" =~ ^[0-9]+$ ]]; then
      echo "Invalid option."
      continue
    fi

    if [ "$crack_action" -eq 1 ]; then
      read -r -p "Capture file (e.g. capture-01.cap): " capture_file
      read -r -p "Target BSSID (for WEP): " wep_bssid
      echo "Running: aircrack-ng -b $wep_bssid $capture_file"
      aircrack-ng -b "$wep_bssid" "$capture_file"

    elif [ "$crack_action" -eq 2 ]; then
      read -r -p "Wordlist path: " dict_file
      read -r -p "Capture file with handshake: " handshake_file
      echo "Running dictionary attack: aircrack-ng -w $dict_file $handshake_file"
      aircrack-ng -w "$dict_file" "$handshake_file"
    else
      echo "Returning to main menu."
    fi

  else
    echo "Invalid main menu option."
  fi

  echo ""
  read -r -p "Press ENTER to return to menu..."
  clear
done
