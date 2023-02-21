#!/bin/bash

interfaces=() # List of interfaces
ip_idx=0 #Index of the current IP address in the list of interfaces

# Iterate over all interfaces and perform a request using their IP addresses
for interface in $(ip link show | grep 'state UP' | awk '{print $2}' | sed 's/://g'); do
  interfaces+=("$interface")
done

while true; do
  if (( ip_idx >= ${#interfaces[@]} )); then
    echo "No more interfaces to use. Exiting."
    exit 1
  fi

  interface=${interfaces[$ip_idx]}
  output=$(ip addr show $interface) # Get the output of the command ip addr show for the current interface
  ip=$(echo $output | grep -oP "(?<=inet\s)\d+\.\d+\.\d+\.\d+" | head -1) # Get the current IP address from the command output
  echo "Using IP address $ip on interface $interface for this request"

  # Execute request
  curl --interface $ip http://2ip.ru

  # Increase index of IP address
  ip_idx=$((ip_idx + 1))

  # Check if next interface available
  if [[ ! "${interfaces[$ip_idx]}" ]]; then
    echo "No more interfaces to use. Exiting."
    exit 1
  fi

  sleep 1
done
