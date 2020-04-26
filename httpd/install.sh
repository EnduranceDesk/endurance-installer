# @Author: Nawaz Sarwar
# @Date:   2020-04-08 15:36:44
# @Last Modified by:   Adnan
# @Last Modified time: 2020-04-27 03:39:37
clear
echo "***************************************";
echo "*           Apache Installing         *"
echo "***************************************";

yum info httpd
echo "Installing httpd"
yum -y install httpd mod_ssl  mod_security  mod_security_crs
# yum -y install https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/m/mod_ruid2-0.9.8-2.el7.x86_64.rpm
echo "httpd installation successfull"

echo "Creating Directory Structure"
# mkdir /etc/endurance/configs/httpd

cp -r -v /etc/httpd /etc/endurance/configs/
mkdir -p /etc/endurance/configs/httpd/default.document.root/html
mkdir -p /etc/endurance/configs/httpd/vhosts
mkdir -p /etc/endurance/configs/httpd/panel_logs
touch /etc/endurance/configs/httpd/othervhosts.conf

chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/panel_logs
chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/vhosts
chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/othervhosts.conf
chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/default.document.root/html

# mkdir /etc/endurance/configs/httpd/conf
# mkdir /etc/endurance/configs/httpd/conf.d
# mkdir /etc/endurance/configs/httpd/conf.modules.d

cp -v /etc/endurance/repo/endurance-installer/httpd/standby/myhttpd.conf /etc/endurance/configs/httpd/conf/httpd.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/mime.types /etc/endurance/configs/httpd/conf/mime.types

cp -v /etc/endurance/repo/endurance-installer/httpd/standby/endurance_vhosts.conf /etc/endurance/configs/httpd/endurance_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/endurance_ssl_vhosts.conf /etc/endurance/configs/httpd/endurance_ssl_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/rover_vhosts.conf /etc/endurance/configs/httpd/rover_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/rover_ssl_vhosts.conf /etc/endurance/configs/httpd/rover_ssl_vhosts.conf
# mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup

# cp  -r -v standby/httpd.conf /etc/httpd/conf/httpd.conf
cp  -r -v /etc/endurance/repo/endurance-installer/httpd/standby/index.html /etc/endurance/configs/httpd/default.document.root/html/index.html


chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/conf/*
chcon --type httpd_sys_rw_content_t /etc/endurance/configs/httpd/*


# cp -r -v /etc/httpd/conf.d/* /etc/endurance/configs/httpd/conf.d/
# mv /etc/httpd/conf.d /etc/httpd/conf.d.backup

# cp -r -v /etc/httpd/conf.modules.d/* /etc/endurance/configs/httpd/conf.modules.d/
# mv /etc/httpd/conf.modules.d /etc/httpd/conf.modules.d.backup

rm -rf /etc/httpd
rm -rf /etc/endurance/configs/httpd/logs
rm -rf /etc/endurance/configs/httpd/modules
rm -rf /etc/endurance/configs/httpd/run
rm -rf /etc/endurance/configs/httpd/state
rm /etc/endurance/configs/httpd/conf.d/welcome.conf

ln -s /etc/endurance/configs/httpd /etc/httpd
ln -s /var/log/httpd /etc/endurance/configs/httpd/logs
ln -s /usr/lib64/httpd/modules /etc/endurance/configs/httpd/modules
ln -s /run/httpd /etc/endurance/configs/httpd/run
ln -s /var/lib/httpd /etc/endurance/configs/httpd/state


echo "Starting Apache"
systemctl start httpd
echo "Make sure that Apache starts at Boot"
systemctl enable httpd
echo "Checking status of httpd"
systemctl is-active --quiet httpd && echo Apache is running.


echo "Adding apache, endurance and rover ports through firewall"
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp

semanage port -a -t http_port_t -p tcp 80
semanage port -a -t http_port_t -p tcp 443

#Endurance 
firewall-cmd --permanent --add-port=1023/tcp
firewall-cmd --permanent --add-port=1024/tcp

semanage port -a -t http_port_t -p tcp 1023
semanage port -a -t http_port_t -p tcp 1024

#Rower
firewall-cmd --permanent --add-port=1025/tcp
firewall-cmd --permanent --add-port=1026/tcp

semanage port -a -t http_port_t -p tcp 1025
semanage port -a -t http_port_t -p tcp 1026

firewall-cmd --reload
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload
systemctl restart firewalld.service

if 
systemctl is-active --quiet httpd
then
echo Apache is Up and Running.
else
  echo Apache is Down and Not Running. SysLinux ports may need a minute or two to register. Do not lose hope.
fi

echo "***************************************";
echo "*           Apache Installed          *"
echo "***************************************";
