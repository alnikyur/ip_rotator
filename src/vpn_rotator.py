#!/usr/bin/env python3

import socket
import argparse
import nmap



parser = argparse.ArgumentParser()
parser.add_argument('--ports', nargs='+', type=int,default=["20", "21", "80", "443"], help='list of ports to scan')
parser.add_argument('--interfaces', nargs='+', type=str, default=['tun0', 'tun1'], help='list of interfaces to use')
parser.add_argument('--host', type=str, default='195.201.201.32', help='host to scan')
args = parser.parse_args()


#=================================#

for port in args.ports:
    j = args.ports.index(port) % len(args.interfaces)
    nmScan = nmap.PortScanner()
    arg = '-e' + f"{args.interfaces[j]}"
    res = nmScan.scan(args.host, f"{port}", arguments=arg)
    print("Port is:", int(port), res['scan'][args.host]['tcp'][int(port)]['state'])
