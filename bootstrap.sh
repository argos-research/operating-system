
##############################
#
# This is a bootstrap script which is
# run at every startup of the vagrant machine
# If you want to run something just once at provisioning
# and first bootup of the vagrant machine please see
# provision.sh
#
# Contributor: Bernhard Blieninger
##############################


#systemctl stop NetworkManager.service
ip a add 10.200.40.1/21 dev enp0s8
ip l set up dev enp0s8
# copy config for dhcp server
cp /vagrant/config-data/dhcpd.conf /etc/dhcp/dhcpd.conf
/vagrant/config-data/tftp-folder.sh
# start dhcp server
systemctl start isc-dhcp-server.service
