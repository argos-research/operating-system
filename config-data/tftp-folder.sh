#!/bin/bash
#Generates the needed tftp folders.. see dhcpd.conf in /etc/dhcp/dhcpd.conf for folders you might need
echo "Generating Folders for TFTPD Boot please refer to /etc/dhcp/dhcpd.conf to find corresponding machines"

boards=(pandaboard raspberry odroid zedzybo qemuvm)

for board in ${boards[*]}
do
	for i in `seq 1 5;`
	do
		mkdir -p /var/lib/tftpboot/$board/$i
	done
done
