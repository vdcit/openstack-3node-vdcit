#!/bin/bash -ex
#
# RABBIT_PASS=a
# ADMIN_PASS=a

source config.cfg

SERVICE_ID=`keystone tenant-get service | awk '$2~/^id/{print $4}'`


echo "############ Cau hinh forward goi tin cho cac VM ############"
sleep 7 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
sysctl -p 

echo "########## CAI DAT NEUTRON TREN $HOST_NAME ##########"
sleep 5
apt-get -y install neutron-server neutron-plugin-ml2 neutron-plugin-openvswitch-agent openvswitch-datapath-dkms neutron-l3-agent neutron-dhcp-agent

######## SAO LUU CAU HINH NEUTRON.CONF CHO $HOST_NAME##################"
echo "########## SUA FILE CAU HINH  NEUTRON CHO $HOST_NAME ##########"
sleep 7

#
controlneutron=/etc/neutron/neutron.conf
test -f $controlneutron.orig || cp $controlneutron $controlneutron.orig
rm $controlneutron
touch $controlneutron
cat << EOF >> $controlneutron
[DEFAULT]
state_path = /var/lib/neutron
lock_path = $state_path/lock
core_plugin = ml2
service_plugins = router
auth_strategy = keystone
allow_overlapping_ips = True
rpc_backend = neutron.openstack.common.rpc.impl_kombu
rabbit_host = $CON_MGNT_IP
rabbit_password = $ADMIN_PASS
rabbit_userid = guest
notification_driver = neutron.openstack.common.notifier.rpc_notifier
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
nova_url = http://$HOST_NAME:8774/v2/v2
nova_admin_username = nova
nova_admin_tenant_id = $SERVICE_ID
nova_admin_password = $ADMIN_PASS
nova_admin_auth_url = http://$HOST_NAME:35357/v2.0

[quotas]

[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf

[keystone_authtoken]
auth_host = 127.0.0.1
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = $ADMIN_PASS
signing_dir = $state_path/keystone-signing

[database]
connection = mysql://neutron:$ADMIN_PASS@$HOST_NAME/neutron

[service_providers]
service_provider=LOADBALANCER:Haproxy:neutron.services.loadbalancer.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default
service_provider=VPN:openswan:neutron.services.vpn.service_drivers.ipsec.IPsecVPNDriver:default

EOF


######## SAO LUU CAU HINH ML2 CHO $HOST_NAME##################"
echo "########## SUA FILE CAU HINH  ML2 CHO $HOST_NAME ##########"
sleep 7

controlML2=/etc/neutron/plugins/ml2/ml2_conf.ini
test -f $controlML2.orig || cp $controlML2 $controlML2.orig
rm $controlML2
touch $controlML2

cat << EOF >> $controlML2
[ml2]
type_drivers = vlan
tenant_network_types = vlan
mechanism_drivers = openvswitch

[ml2_type_flat]

[ml2_type_vlan]
# "vm network" - tag range, from 200 to 400
network_vlan_ranges = physnet1:10:40

[ml2_type_gre]

[ml2_type_vxlan]

[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver

[ovs]
enable_tunneling = False
tenant_network_type = vlan
integration_bridge = br-int
network_vlan_ranges = physnet1:10:40
bridge_mappings = physnet1:br-eth1
EOF

echo "############  Sua file cau hinh DHCP AGENT ############ "
sleep 7 
#
netdhcp=/etc/neutron/dhcp_agent.ini

test -f $netdhcp.orig || cp $netdhcp $netdhcp.orig
rm $netdhcp
touch $netdhcp

cat << EOF >> $netdhcp
[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
verbose = True
EOF

echo "############  Sua file cau hinh METADATA AGENT ############"
sleep 7 
#
netmetadata=/etc/neutron/metadata_agent.ini

test -f $netmetadata.orig || cp $netmetadata $netmetadata.orig
rm $netmetadata
touch $netmetadata

cat << EOF >> $netmetadata
[DEFAULT]
auth_url = http://$HOST_NAME:5000/v2.0
auth_region = regionOne
admin_tenant_name = service
admin_user = neutron
admin_password = $ADMIN_PASS
nova_metadata_ip = $HOST_NAME
metadata_proxy_shared_secret = $METADATA_SECRET
verbose = True
EOF
#

echo "########## KHOI DONG LAI NOVA ##########"
sleep 7 
service nova-api restart
service nova-scheduler restart
service nova-conductor restart

echo "########## KHOI DONG LAI NEUTRON ##########"
sleep 7 
service neutron-server restart
service neutron-plugin-openvswitch-agent restart
service neutron-dhcp-agent restart
service neutron-metadata-agent restart


