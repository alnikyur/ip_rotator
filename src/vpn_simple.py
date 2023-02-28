#!/usr/bin/env python3

import nmap
host='195.201.201.32'
#=================================#

ports = ["20", "21", "80", "443"]
interfaces = ["tun0", "tun1"]

for i in range(len(ports)):
    j = i % len(interfaces)

#=================================#

    nmScan = nmap.PortScanner()
    arg = '-e' + f"{interfaces[j]}"
    res = nmScan.scan(host, f"{ports[i]}", arguments=arg)
    print("Port is:", int(ports[i]), res['scan'][host]['tcp'][int(ports[i])]['state'])

