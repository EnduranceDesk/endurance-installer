# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-06-04 20:58:35
clear
echo "***************************************";
echo "*   General CLI PHP FPM Installing    *"
echo "***************************************";

yum install httpd -y
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
yum install http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum install yum-utils -y
yum install php56 -y
yum install php72 -y
yum install php56-php-fpm -y
yum install php72-php-fpm -y

systemctl stop php56-php-fpm
systemctl stop php72-php-fpm

yum -y install php56-php-cli php56-php-common  php56-php-opcache php56-php-zip php56-php-json php56-php-mbstring php56-php-gettext php56-php-xml php56-php-bcmath php56-php-dba php56-php-dbg php56-php-mysqlnd php56-php-odbc php56-php-gd php56-php-pdo php56-php-gmp php56-php-gd php56-php-ldap php56-php-odbc php56-php-pear php56-php-xml php56-php-xmlrpc php56-php-mbstring php56-php-soap curl curl-devel
yum -y install php72-php-cli php72-php-common  php72-php-opcache php72-php-zip php72-php-json php72-php-mbstring php72-php-gettext php72-php-xml php72-php-bcmath php72-php-dba php72-php-dbg php72-php-mysqlnd php72-php-odbc php72-php-gd php72-php-pdo php72-php-gmp php72-php-gd php72-php-ldap php72-php-odbc php72-php-pear php72-php-xml php72-php-xmlrpc php72-php-mbstring php72-php-soap curl curl-devel
echo "PHP Installed"



echo "Turn off apache security2_module"
sed -i 's+##LoadModule+#LoadModule+g' /etc/endurance/configs/httpd/conf.modules.d/10-mod_security.conf
sed -i 's+LoadModule security2_module modules/mod_security2.so+#LoadModule security2_module modules/mod_security2.so+g' /etc/endurance/configs/httpd/conf.modules.d/10-mod_security.conf
echo "security2_module turned off"


echo "Allowing PHP7.2 to run as root"
sed -i 's+--nodaemonize -R+--nodaemonize+g' /lib/systemd/system/php72-php-fpm.service
echo "Allowed"


echo "Enable home dir access through SELinux"
setsebool -P httpd_enable_homedirs true
semanage fcontext -a -t httpd_sys_content_t /home/adnan/
semanage fcontext -a -t httpd_sys_content_t /home/endurance/
semanage fcontext -a -t httpd_sys_content_t /home/rover/
echo "Enabled home dir access through SELinux"

systemctl restart httpd php56-php-fpm php72-php-fpm
systemctl enable httpd
systemctl enable php56-php-fpm
systemctl enable php72-php-fpm
echo "***************************************";
echo "*    General CLI PHP FPM Installed    *"
echo "***************************************";

clear

echo "***************************************";
echo "*      Installing General CLI PHP     *"
echo "***************************************";
yum -y install php php-opcache
yum -y install php-cli php-zip php-json php-mbstring php-gettext php-xml php-bcmath php-dba php-dbg php-mysqlnd php-odbc php-gd php-pdo php-gmp php-opcache php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
echo "***************************************";
echo "*      General CLI PHP Installed      *"
echo "***************************************";

mkdir -p /etc/endurance/configs/php

mkdir -p /etc/endurance/configs/php/php72
chown apache.apache /etc/endurance/configs/php/php72
cp /etc/endurance/repo/endurance-installer/php/standby/endurance72.conf /etc/opt/remi/php72/php-fpm.d/endurance.conf


mkdir -p /etc/endurance/configs/php/php56
chown apache.apache /etc/endurance/configs/php/php56
cp /etc/endurance/repo/endurance-installer/php/standby/endurance56.conf /etc/opt/remi/php56/php-fpm.d/endurance.conf


semanage fcontext -at httpd_sys_rw_content_t "/etc/endurance/configs/php(/.*)?"
restorecon -R -v '/etc/endurance/configs/php' 


systemctl restart  httpd php56-php-fpm php72-php-fpm