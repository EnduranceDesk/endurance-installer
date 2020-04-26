echo "Stopping httpd"
systemctl stop httpd
systemctl is-active --quiet httpd && echo Bind is still running.

echo "Uninstalling Httpd and mod_ssl"
yum remove httpd mod_ssl mod_security  mod_security_crs  -y
yum remove mod_ruid2

echo "Removing apache, endurance and rover ports from firewall"
firewall-cmd --permanent --remove-port=80/tcp
firewall-cmd --permanent --remove-port=443/tcp
semanage port -d -t http_port_t -p tcp 80
semanage port -d -t http_port_t -p tcp 443

#Endurance 
firewall-cmd --permanent --remove-port=1023/tcp
firewall-cmd --permanent --remove-port=1024/tcp
semanage port -d -t http_port_t -p tcp 1023
semanage port -d -t http_port_t -p tcp 1024

#Rower
firewall-cmd --permanent --remove-port=1025/tcp
firewall-cmd --permanent --remove-port=1026/tcp
semanage port -d -t http_port_t -p tcp 1025
semanage port -d -t http_port_t -p tcp 1026


firewall-cmd --reload
firewall-cmd --zone=public --remove-service=http --permanent
firewall-cmd --zone=public --remove-service=https --permanent
firewall-cmd --reload

rm -rf /etc/endurance/configs/httpd
rm -rf /etc/httpd

echo "HTTPD REMOVED"