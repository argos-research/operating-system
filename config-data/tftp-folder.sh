#!/bin/bash
#Generates the needed tftp folders.. see dhcpd.conf in /etc/dhcp/dhcpd.conf for folders you might need
echo "Generating Folders for TFTPD Boot please refer to /etc/dhcp/dhcpd.conf to find corresponding machines"

for i in `seq 1 5;`
do
mkdir -p /var/lib/tftpboot/pandaboard/$i
done
for i in `seq 1 5;`
do
mkdir -p /var/lib/tftpboot/raspberry/$i
done
for i in `seq 1 5;`
do
mkdir -p /var/lib/tftpboot/odroid/$i
done
for i in `seq 1 5;`
do
mkdir -p /var/lib/tftpboot/zedzybo/$i
done
for i in `seq 1 5;`
do
mkdir -p /var/lib/tftpboot/qemuvm/$i
done
