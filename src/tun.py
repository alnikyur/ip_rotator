#!/usr/bin/env python3

import nmap
import netifaces
import xml.etree.ElementTree as ET
import os

# Get the list of available tun interfaces
interfaces = netifaces.interfaces()
tun_interfaces = [interface for interface in interfaces if 'tun' in interface and 'tunl0' not in interface]

# Set the target host to scan
host = '34.207.222.129'

# Set the list of ports to scan
ports = ['20', '21', '80', '443']

# Set the path and name of the output XML file
output_dir = '/tmp/webmap/'
os.makedirs(output_dir, exist_ok=True)
output_file = output_dir + 'output.xml'

# Create a new XML tree with the 'nmaprun' root element
root = ET.Element('nmaprun')

# Load the existing XML file (if it exists)
if os.path.isfile(output_file) and os.path.getsize(output_file) > 0:
    tree = ET.parse(output_file)
    root = tree.getroot()

# Iterate over the ports to scan
for i in range(len(ports)):
    j = i % len(tun_interfaces)

    # Perform the Nmap scan
    nmScan = nmap.PortScanner()
    arg = '-e' + tun_interfaces[j]
    res = nmScan.scan(host, ports[i], arguments=arg)

    # Parse the scan results and add them to the XML tree
    new_results = ET.fromstring(nmScan.get_nmap_last_output())
    for child in new_results:
        root.append(child)

# Write the updated XML tree to the output file
with open(output_file, 'wb') as f:
    f.write(ET.tostring(root, encoding='UTF-8', xml_declaration=True))
