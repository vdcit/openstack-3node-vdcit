 # hd-caidat-openstack-icehouse-multi-node-u14-vlan.md


# Mô hình


# Các bước thực hiện

## Cài đặt trên Controller 
```sh
apt-get install git -y

git clone https://github.com/vdcit/openstack-3node-vdcit.git

mv openstack-3node-vdcit/script-U1404-VLAN/ /root && rm -rf /root/openstack-3node-vdcit/

cd script-U1404-VLAN/ 

chmod +x *.sh

```
### Thiết lập địa chỉ IP cho các NICs
- Thiết lập địa chỉ IP các các NICs sau đó khởi động lại.
```sh
bash control-1.ipadd.sh
```

### Cài đặt các gói chuẩn bị trên CONTROLLER
` Đăng nhập với quyền root và thực thi script dưới (nếu cần kiểm tra lại kết nối internet bằng lệnh ping)
```sh
cd script-U1404-VLAN

bash control-2.prepare.sh 
```

### Cài đặt và tạo DB cho các OpenStack
```sh
bash control-3.create-db.sh
```
- Sau khi cài đặt xogn DB có thể kiểm tra xem đã có các DB được tạo ra hay chưa bằng các lệnh quản trị của MYSQL
- Nếu OK thì chuyển sang script tiếp theo.

### Cài đặt Keystone 
- Thực hiện cài đặt Keystone cho OpenStack
```sh 
bash control-4.keystone.sh
```
### Tạo user, role, tenant, phân quyền cho user và tạo các endpoint
- Shell dưới thực hiện việc tạo user, tenant và gán quyền cho các user. 
<br>Tạo ra các endpoint cho các dịch vụ. Các biến trong shell được lấy từ file config.cfg
```sh
bash control-5-creatusetenant.sh
```
- Thực thi file admin-openrc.sh để khai báo biến môi trường.
```sh 
source admin-openrc.sh
```
- Và kiểm tra lại dịch vụ keystone xem đã hoạt động tốt chưa bằng lệnh dưới.
```sh
keystone catalog
```
Kết quả của lệnh trên sẽ hiện thị các thông tin của các service (ID, URL, region) trong OpenStack 

### Cài đặt thành phần GLANCE
GLANCE dùng để cung cấp image template để khởi tạo máy ảo
```sh
bash control-6.glance.sh
```
- Shell thực hiện việc cài đặt GLANCE và tạo image với hệ điều hành Cirros (Bản Ubuntu thu gọn) dùng để kiểm tra GLANCE và tạo máy ảo sau này.

### Cài đặt NOVA
```sh
bash control-7.nova.sh
```

### Cài đặt NEUTRON
```sh
bash control-8.neutron.sh
```

### Cài đặt CINDER
```sh
bash control-9.neutron.sh
```

## Cài đặt trên COMPUTE 1
Thực hiện trên COMPUTE 1
```sh
apt-get install git -y

git clone https://github.com/vdcit/openstack-3node-vdcit.git

mv openstack-3node-vdcit/script-U1404-VLAN/ /root && rm -rf /root/openstack-3node-vdcit/

cd script-U1404-VLAN/ 

chmod +x *.sh
```

### Thiết lập địa chỉ IP cho các NICs
- Thiết lập địa chỉ IP các các NICs sau đó khởi động lại.
```sh
bash com1-ipdd.sh
```

### Cài đặt các gói và cấu hình COMPUTE
- Đăng nhập với quyền root và kiểm tra kết nối internet bằng lệnh ping để kiểm tra IP Address đã đúng hay chưa.
- Thực thi script để cài đặt các gói trên máy COMPUTE 
```sh
cd script-U1404-VLAN/ 

bash com1-prepare.sh
ls
```

###  Tạo các network cho OpenStack
Thực thi trên CONTROLLER NODE
- Tạo Network cho VLAN 10
```sh
neutron net-create vlan10 --provider:network_type vlan --provider:physical_network physnet1 --provider:segmentation_id 10 --shared --router:external=True
```
- Tạo subnnet cho VLAN 10 vừa tạo ở trên
 ```sh
neutron subnet-create --name subnet10 --allocation-pool start=192.168.10.10,end=192.168.10.254 vlan10 192.168.10.0/24 --dns_nameservers list=true 8.8.8.8
```

- Tạo Network cho VLAN 20
```sh
neutron net-create vlan20 --provider:network_type vlan --provider:physical_network physnet1 --provider:segmentation_id 20 --shared --router:external=True
```
- Tạo subnnet cho VLAN 20 vừa tạo ở trên
```sh
neutron subnet-create --name subnet20 --allocation-pool start=192.168.20.10,end=192.168.20.254 vlan20 192.168.20.0/24 --dns_nameservers list=true 8.8.8.8
```

- Kiểm tra các network vừa tạo bằng lệnh dưới
```sh
neutron net-list
```


#### Tao may ao
- Thay dòng `ID_cua_cac_network_o_tren` vào trong dòng lệnh dưới để tạo máy ảo.
```sh
nova boot --image cirros-0.3.2-x86_64 --flavor m1.tiny --nic net-id=ID_cua_cac_network_o_tren VLAN10-vm1
```

### Cài đặt Horizon
Sau khi cài đặt trên COMPUTE 1 xong, quay trở lại node Controller để cài đặt horizon

```sh
bash /root/script-U1404-VLAN/control-horizon.sh
```

- Kết thúc việc cài đặt horizon - bạn sẽ nhận được thông báo và URL truy cập vào hệ thống.
- Bắt đầu sử dụng hệ thống


