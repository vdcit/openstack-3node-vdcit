 # hd-caidat-openstack-icehouse-multi-node-u14-vlan.md


# Mô hình


## Các bước thực hiện

### Cài đặt trên Controller 
```sh
apt-get install git -y
git clone https://github.com/vdcit/openstack-3node-vdcit.git
 mv openstack-3node-vdcit/script-U1404-VLAN/ /root && rm -rf /root/openstack-3node-vdcit/
cd script-U1404-VLAN/ 
chmod +x *.sh
```
