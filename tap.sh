# add tap device
sudo ip tuntap add name tap0 mode tap
# add bridge device
sudo ip link add name br0 type bridge
# assign ip address to bridge device
sudo ip addr add 10.0.0.1/24 dev br0
# assign tap device to bridge device
sudo ip link set tap0 master br0
# set status of both devices to up
sudo ip link set up dev tap0
sudo ip link set up dev br0
# start dnsmasq for dhcp on bridge device
sudo dnsmasq -p 0 -i br0 -F 10.0.0.2,10.0.0.5,255.255.255.0

sudo sysctl net.ipv4.conf.all.forwarding=1

sudo iptables -t nat -A POSTROUTING -o enp0s31f6 -j MASQUERADE
