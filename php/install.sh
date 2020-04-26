# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-04-27 03:40:54
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

# echo "Allowing apache to use intra-network connections"
# setsebool -P httpd_can_network_connect 1
# echo "Apache allowed to use intra-network connections"

# echo "Alloting port 9002 and 9003 for php56 and php72 respectively"
# semanage port -a -t http_port_t -p tcp 9002
# semanage port -a -t http_port_t -p tcp 9003
# echo "Alloted"


echo "Configuring PHP FPM for PHP 5.6"
mkdir -p /var/www/cgi-bin/
mkdir -p /var/www/cgi-bin/endurance
chown endurance.endurance /var/www/cgi-bin/endurance
chown endurance.endurance /var/www/cgi-bin/endurance/*

#echo "user = nobody" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#echo "group = nobody" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#echo "listen = 127.0.0.1:2" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#sed -i 's+SetHandler "proxy:unix:/var/opt/remi/php56/run/php-fpm/www.sock|fcgi://localhost"+SetHandler "proxy:fcgi://127.0.0.1:9002"+g' /etc/endurance/configs/httpd/conf.d/php56-php.conf
#systemctl restart php56-php-fpm

touch /var/www/cgi-bin/endurance/php56.fcgi
cat > /var/www/cgi-bin/endurance/php56.fcgi << EOF
#!/bin/bash
exec /bin/php56-cgi
EOF
chmod 755 /var/www/cgi-bin/endurance/php56.fcgi
echo "PHP FPM Configured for PHP 5.6"

echo "Configuring PHP FPM for PHP 7.2"
#echo "user = nobody" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#echo "group = nobody" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#echo "listen = 127.0.0.1:9003" >>  /etc/opt/remi/php72/php-fpm.d/www.conf
#sed -i 's+SetHandler "proxy:unix:/var/opt/remi/php72/run/php-fpm/www.sock|fcgi://localhost"+SetHandler "proxy:fcgi://127.0.0.1:9003"+g' /etc/endurance/configs/httpd/conf.d/php72-php.conf
#systemctl restart php72-php-fpm


touch /var/www/cgi-bin/endurance/php72.fcgi
cat > /var/www/cgi-bin/endurance/php72.fcgi << EOF
#!/bin/bash
exec /bin/php72-cgi
EOF
chmod 755 /var/www/cgi-bin/endurance/php72.fcgi


# mv /etc/endurance/configs/httpd/conf.d/php72-php.conf /etc/endurance/configs/httpd/conf.d/php72-php.confd
echo "PHP FPM Configured for PHP 7.2"


echo "Turn off apache security2_module"
sed -i 's+##LoadModule+#LoadModule+g' /etc/endurance/configs/httpd/conf.modules.d/10-mod_security.conf
sed -i 's+LoadModule security2_module modules/mod_security2.so+#LoadModule security2_module modules/mod_security2.so+g' /etc/endurance/configs/httpd/conf.modules.d/10-mod_security.conf
echo "security2_module turned off"


# echo "Making aggregated php configuration file"
# cat > /etc/httpd/conf.d/php.conf << EOF
# ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
# AddHandler php56-fcgi .php
# Action php56-fcgi /cgi-bin/php56.fcgi
# Action php72-fcgi /cgi-bin/php72.fcgi

# EOF
# echo "Aggregated php configuration file built"


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

mkdir -p /var/run/php

mkdir -p /var/run/php/php72
touch /var/run/php/php72/endurance.sock 
chown apache.apache /var/run/php/php72/endurance.sock
cp /etc/endurance/repo/endurance-installer/php/standby/endurance72.conf /etc/opt/remi/php72/php-fpm.d/endurance.conf


mkdir -p /var/run/php/php56
touch /var/run/php/php56/endurance.sock 
chown apache.apache /var/run/php/php56/endurance.sock

cp /etc/endurance/repo/endurance-installer/php/standby/endurance56.conf /etc/opt/remi/php56/php-fpm.d/endurance.conf

systemctl restart  httpd php56-php-fpm php72-php-fpm

