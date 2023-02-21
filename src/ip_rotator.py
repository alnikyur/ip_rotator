import subprocess
import requests

# Get list of all interfaces
interfaces = subprocess.check_output("ip -o link show | awk -F': ' '{print $2}' | awk '{print $1}'", shell=True, text=True).split("\n")

interfaces.pop()

# Get IP addresses for each interface
ips = {}
for interface in interfaces:
    ip_output = subprocess.check_output(f"ip -o -4 addr show dev {interface} | awk '{{print $4}}' | cut -d'/' -f1", shell=True, text=True)
    ip = ip_output.strip()
    ips[interface] = ip

# Iterate through all interfaces and perform a request using their IP addresses
for interface, ip in ips.items():
    print(f"Using IP address {ip} on interface {interface} for this request")
    response = requests.get("https://api.myip.com", headers={"User-Agent": "Mozilla/5.0"}, timeout=10, proxies={"http": f"{ip}:80"})

    # Check if there any othoer interfaces exist
    if len(ips) == 1:
        break

    # Remove the used interface from the dictionary
    del ips[interface]
