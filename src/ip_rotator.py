import subprocess
import netifaces as ni
import random
import sys

url = sys.argv[1]

# Getting the list of available interfaces
interfaces = ni.interfaces()

print(interfaces)

# Getting IP addresses for each interface
addresses = {}
for iface in interfaces:
    try:
        address = ni.ifaddresses(iface)[ni.AF_INET][0]['addr']
        addresses[iface] = address
    except:
        pass

# Main program loop
while len(addresses) > 0:
    #  Choosing a random interface from the available ones
    iface = random.choice(list(addresses.keys()))

    # Getting the current IP address for the selected interface
    ip_address = addresses[iface]

    # Sending a request using the current IP address
    cmd = ['curl', '-l', url]
    subprocess.run(cmd)

    print(iface)

    # Removing the used interface from the dictionary
    del addresses[iface]
