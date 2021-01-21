# @Author: Nawaz Sarwar
# @Date:   2020-04-08 15:36:44
# @Last Modified by:   Adnan Hussain Turki
# @Last Modified time: 2021-01-21 06:09:57
clear
echo "***************************************";
echo "*           Apache Installing         *"
echo "***************************************";

yum info httpd
yum -y install httpd mod_ssl  mod_security  mod_security_crs



#BUILDING DISCOVERY
cp -rf  /etc/httpd /etc/endurance/configs/
mv /etc/endurance/configs/httpd /etc/endurance/configs/discovery
mkdir -p /etc/endurance/configs/discovery/default.document.root/html
mkdir -p /etc/endurance/configs/discovery/vhosts
mkdir -p /etc/endurance/configs/discovery/discovery_log
touch /etc/endurance/configs/discovery/othervhosts.conf

cp -rf /etc/endurance/repo/endurance-installer/httpd/standby/conf/discovery.conf /etc/endurance/configs/discovery/conf/httpd.conf
cp -rf /etc/endurance/repo/endurance-installer/httpd/standby/mime.types /etc/endurance/configs/discovery/conf/mime.types
cp  -r -v /etc/endurance/repo/endurance-installer/httpd/standby/index.html /etc/endurance/configs/discovery/default.document.root/html/index.html



firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

#BUILDING APOLLO
cp -rf  /etc/httpd /etc/endurance/configs/
mv /etc/endurance/configs/httpd /etc/endurance/configs/apollo
mkdir -p /etc/endurance/configs/apollo/apollo_log
cp -rf /etc/endurance/repo/endurance-installer/httpd/standby/conf/apollo.conf /etc/endurance/configs/apollo/conf/httpd.conf
cp -rf /etc/endurance/repo/endurance-installer/httpd/standby/mime.types /etc/endurance/configs/apollo/conf/mime.types

cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/endeavour_vhosts.conf /etc/endurance/configs/apollo/endeavour_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/endeavour_ssl_vhosts.conf /etc/endurance/configs/apollo/endeavour_ssl_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/endurance_vhosts.conf /etc/endurance/configs/apollo/endurance_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/endurance_ssl_vhosts.conf /etc/endurance/configs/apollo/endurance_ssl_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/rover_vhosts.conf /etc/endurance/configs/apollo/rover_vhosts.conf
cp -v /etc/endurance/repo/endurance-installer/httpd/standby/vhosts/rover_ssl_vhosts.conf /etc/endurance/configs/apollo/rover_ssl_vhosts.conf

cp -v /etc/endurance/repo/endurance-installer/httpd/standby/apollo.service /lib/systemd/system/apollo.service

sed -i "s+Listen 443 https+#Listen 443 https+g" /etc/endurance/configs/apollo/conf.d/ssl.conf

sed -i "s+__HOSTNAME__+$(hostname)+g" /etc/endurance/configs/apollo/endeavour_vhosts.conf
sed -i "s+__HOSTNAME__+$(hostname)+g" /etc/endurance/configs/apollo/endurance_vhosts.conf
sed -i "s+__HOSTNAME__+$(hostname)+g" /etc/endurance/configs/apollo/rover_vhosts.conf

firewall-cmd --permanent --add-port=1021/tcp
firewall-cmd --permanent --add-port=1022/tcp
firewall-cmd --permanent --add-port=1023/tcp
firewall-cmd --permanent --add-port=1024/tcp
firewall-cmd --permanent --add-port=1025/tcp
firewall-cmd --permanent --add-port=1026/tcp
firewall-cmd --reload

#CLEANING UP THE DOCK
rm -rf /etc/httpd
rm -rf /etc/endurance/configs/discovery/logs
rm -rf /etc/endurance/configs/discovery/modules
rm -rf /etc/endurance/configs/discovery/run
rm -rf /etc/endurance/configs/discovery/state
rm -f /etc/endurance/configs/discovery/conf.d/welcome.conf

rm -rf /etc/endurance/configs/apollo/logs
rm -rf /etc/endurance/configs/apollo/modules
rm -rf /etc/endurance/configs/apollo/run
rm -rf /etc/endurance/configs/apollo/state
rm -f /etc/endurance/configs/apollo/conf.d/welcome.conf


#LINKING
ln -s /etc/endurance/configs/discovery /etc/httpd
ln -s /var/log/httpd /etc/endurance/configs/discovery/logs
ln -s /usr/lib64/httpd/modules /etc/endurance/configs/discovery/modules
ln -s /run/httpd /etc/endurance/configs/discovery/run
ln -s /var/lib/httpd /etc/endurance/configs/discovery/state


ln -s /var/log/httpd /etc/endurance/configs/apollo/logs
ln -s /usr/lib64/httpd/modules /etc/endurance/configs/apollo/modules
ln -s /run/httpd /etc/endurance/configs/apollo/run
ln -s /var/lib/httpd /etc/endurance/configs/apollo/state

systemctl daemon-reload
systemctl enable httpd apollo
systemctl start httpd apollo
systemctl is-active --quiet httpd && echo Discovery is running.
systemctl is-active --quiet apollo && echo Apollo is running.
systemctl restart firewalld.service


echo "***************************************";
echo "*           Apache Installed          *"
echo "***************************************";
