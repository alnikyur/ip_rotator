#!/usr/bin/env python3

import nmap
import netifaces

interfaces = netifaces.interfaces()
tun_interfaces = []

for interface in interfaces:
    if 'tun' in interface and 'tunl0' not in interface:
        tun_interfaces.append(interface)

host='34.207.222.129'
#=================================#

ports = ["20", "21", "80", "443"]
#interfaces = ["tun10", "tun11", "tun12"]

for i in range(len(ports)):
    j = i % len(tun_interfaces)

#=================================#

    nmScan = nmap.PortScanner()
    arg = '-e' + f"{tun_interfaces[j]}"
    res = nmScan.scan(host, f"{ports[i]}", arguments=arg)
    print("Port is:", int(ports[i]), res['scan'][host]['tcp'][int(ports[i])]['state'],"| Commmand line is:", res['nmap']['command_line'])
    # print(res)

    # with open('/tmp/webmap/output' + str(ports[i]) + '.xml', 'w') as f:
    #     f.write(nmScan.get_nmap_last_output().decode())
