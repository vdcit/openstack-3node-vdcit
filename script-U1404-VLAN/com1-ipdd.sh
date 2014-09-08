#!/bin/bash -ex

source config.cfg

echo "Cau hinh hostname cho COMPUTE1 NODE"
sleep 3
echo "compute1" > /etc/hostname
hostname -F /etc/hostname


ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address $COM1_MGNT_IP
netmask $NETMASK_ADD
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8


# VLANs NETWORK
auto eth1
iface eth1 inet manual
up ifconfig \$IFACE 0.0.0.0 up
up ip link set \$IFACE promisc on
down ifconfig \$IFACE 0.0.0.0 down
EOF

#Khoi dong lai cac card mang vua dat
#service networking restart

#service networking restart
# ifdown eth0 && ifup eth0
# ifdown eth1 && ifup eth1
# ifdown eth2 && ifup eth2

#sleep 5

init 6
#




