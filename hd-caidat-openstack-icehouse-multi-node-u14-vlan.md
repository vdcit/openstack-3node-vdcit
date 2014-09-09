# MỤC LỤC

- [Mô hình](#user-content-m%C3%B4-h%C3%ACnh)
- [Các bước thực hiện](#user-content-c%C3%A1c-b%C6%B0%E1%BB%9Bc-th%E1%BB%B1c-hi%E1%BB%87n)
	- [Cài đặt trên Controller](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-tr%C3%AAn-controller)
		- [Thiết lập địa chỉ IP cho các NICs](#user-content-thi%E1%BA%BFt-l%E1%BA%ADp-%C4%91%E1%BB%8Ba-ch%E1%BB%89-ip-cho-c%C3%A1c-nics)
		- [Cài đặt các gói chuẩn bị trên CONTROLLER](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-c%C3%A1c-g%C3%B3i-chu%E1%BA%A9n-b%E1%BB%8B-tr%C3%AAn-controller)
		- [Cài đặt và tạo DB cho các OpenStack](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-v%C3%A0-t%E1%BA%A1o-db-cho-c%C3%A1c-openstack)
		- [Cài đặt Keystone](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-keystone)
		- [Tạo user, role, tenant, phân quyền cho user và tạo các endpoint](#user-content-t%E1%BA%A1o-user-role-tenant-ph%C3%A2n-quy%E1%BB%81n-cho-user-v%C3%A0-t%E1%BA%A1o-c%C3%A1c-endpoint)
		- [Cài đặt thành phần GLANCE](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-th%C3%A0nh-ph%E1%BA%A7n-glance)
		- [Cài đặt NOVA](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-nova)
		- [Cài đặt NEUTRON](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-neutron)
		- [Cài đặt CINDER](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-cinder)
	- [Cài đặt trên COMPUTE 1](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-tr%C3%AAn-compute-1)
		- [Thiết lập địa chỉ IP cho các NICs](#user-content-thi%E1%BA%BFt-l%E1%BA%ADp-%C4%91%E1%BB%8Ba-ch%E1%BB%89-ip-cho-c%C3%A1c-nics-1)
		- [Cài đặt các gói và cấu hình COMPUTE](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-c%C3%A1c-g%C3%B3i-v%C3%A0-c%E1%BA%A5u-h%C3%ACnh-compute)
		- [Tạo các network cho OpenStack](#user-content-t%E1%BA%A1o-c%C3%A1c-network-cho-openstack)
			- [Tao may ao](#user-content-tao-may-ao)
		- [Cài đặt Horizon](#user-content-c%C3%A0i-%C4%91%E1%BA%B7t-horizon)


# Mô hình

![Alt text](http://i.imgur.com/fCnidK8.png)

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
Thực thi trên CONTROLLER NODE và khai báo 2 VLAN 10 và VLAN 20 tương ứng với các VLAN trong hệ thống vật lý của bạn.
- Tạo Network cho VLAN 10 và khai báo subnet cho VLAN10
```sh
neutron net-create vlan10 --provider:network_type vlan --provider:physical_network physnet1 \
--provider:segmentation_id 10 --shared --router:external=True

neutron subnet-create --name subnet10 --allocation-pool start=192.168.10.10,end=192.168.10.254 \
vlan10 192.168.10.0/24 --dns_nameservers list=true 8.8.8.8
```

- Tạo Network cho VLAN 20 và khai báo subnet cho VLAN20
```sh
neutron net-create vlan20 --provider:network_type vlan --provider:physical_network physnet1 \
--provider:segmentation_id 20 --shared --router:external=True

neutron subnet-create --name subnet20 --allocation-pool start=192.168.20.10,end=192.168.20.254 \
vlan20 192.168.20.0/24 --dns_nameservers list=true 8.8.8.8
```

- Kiểm tra các network vừa tạo bằng lệnh dưới
```sh
neutron net-list
```
- Kết quả của lệnh trên sẽ như dưới
```sh
root@controller1:~/script-U1404-VLAN# neutron net-list
+--------------------------------------+--------+------------------------------------------------------+
| id                                   | name   | subnets                                              |
+--------------------------------------+--------+------------------------------------------------------+
| b9e3e48c-0cab-4973-9e58-474822ada502 | vlan20 | 0c8ed678-d7d8-4a36-913f-7867b3341f31 192.168.20.0/24 |
| fa96021d-e255-40bb-9faf-ddc5187989e0 | vlan10 | ee010859-7ca8-443f-ae91-03feac34ee79 192.168.10.0/24 |
+--------------------------------------+--------+------------------------------------------------------+
```

#### Tao may ao
- Thay dòng `ID_cua_cac_network_o_tren` vào trong dòng lệnh dưới để tạo máy ảo.
```sh
nova boot VLAN10-vm1 --image cirros-0.3.2-x86_64  --flavor m1.tiny --nic net-id=ID_cua_cac_network_o_tren 
```

### Cài đặt Horizon
Sau khi cài đặt trên COMPUTE 1 xong, quay trở lại node Controller để cài đặt horizon

```sh
bash /root/script-U1404-VLAN/control-horizon.sh
```

- Kết thúc việc cài đặt horizon - bạn sẽ nhận được thông báo và URL truy cập vào hệ thống.
- Bắt đầu sử dụng hệ thống


