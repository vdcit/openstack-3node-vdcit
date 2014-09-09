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


## Cài đặt trên COMPUTE 1
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
