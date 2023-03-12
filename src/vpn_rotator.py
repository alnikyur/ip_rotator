#!/usr/bin/env python3

import socket
import argparse
import nmap



parser = argparse.ArgumentParser()
parser.add_argument('--ports', nargs='+', type=int,default=["20", "21", "80", "443"], help='list of ports to scan')
parser.add_argument('--interfaces', nargs='+', type=str, default=['tun10', 'tun11', 'tun12'], help='list of interfaces to use')
parser.add_argument('--host', type=str, default='34.207.222.129', help='host to scan')
args = parser.parse_args()


#=================================#

for port in args.ports:
    j = args.ports.index(port) % len(args.interfaces)
    nmScan = nmap.PortScanner()
    arg = '-e' + f"{args.interfaces[j]}"
    res = nmScan.scan(args.host, f"{port}", arguments=arg)
#    print("Port is:", int(port), res['scan'][args.host]['tcp'][int(port)]['state'])
    print(res)
    with open('/tmp/webmap/output.xml', 'w') as f:
        f.write(nmScan.get_nmap_last_output().decode())
