# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan Hussain Turki
# @Last Modified time: 2021-01-21 06:45:02
echo "Removing PHP"
yum remove https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
yum remove http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum remove yum-utils -y
yum remove php56 php72 php73 php74 php80 -y
yum remove php56-php-fpm php72-php-fpm php73-php-fpm php74-php-fpm php80-php-fpm -y
systemctl stop php56-php-fpm php72-php-fpm php73-php-fpm php74-php-fpm php80-php-fpm


yum -y remove php56-php-cli php56-php-common  php56-php-opcache php56-php-zip php56-php-json php56-php-mbstring php56-php-gettext php56-php-xml php56-php-bcmath php56-php-dba php56-php-dbg php56-php-mysqlnd php56-php-odbc php56-php-gd php56-php-pdo php56-php-gmp php56-php-gd php56-php-ldap php56-php-odbc php56-php-pear php56-php-xml php56-php-xmlrpc php56-php-mbstring php56-php-soap curl curl-devel
yum -y remove php72-php-cli php72-php-common  php72-php-opcache php72-php-zip php72-php-json php72-php-mbstring php72-php-gettext php72-php-xml php72-php-bcmath php72-php-dba php72-php-dbg php72-php-mysqlnd php72-php-odbc php72-php-gd php72-php-pdo php72-php-gmp php72-php-gd php72-php-ldap php72-php-odbc php72-php-pear php72-php-xml php72-php-xmlrpc php72-php-mbstring php72-php-soap curl curl-devel
yum -y remove php73-php-cli php73-php-common  php73-php-opcache php73-php-zip php73-php-json php73-php-mbstring php73-php-gettext php73-php-xml php73-php-bcmath php73-php-dba php73-php-dbg php73-php-mysqlnd php73-php-odbc php73-php-gd php73-php-pdo php73-php-gmp php73-php-gd php73-php-ldap php73-php-odbc php73-php-pear php73-php-xml php73-php-xmlrpc php73-php-mbstring php73-php-soap curl curl-devel
yum -y remove php74-php-cli php74-php-common  php74-php-opcache php74-php-zip php74-php-json php74-php-mbstring php74-php-gettext php74-php-xml php74-php-bcmath php74-php-dba php74-php-dbg php74-php-mysqlnd php74-php-odbc php74-php-gd php74-php-pdo php74-php-gmp php74-php-gd php74-php-ldap php74-php-odbc php74-php-pear php74-php-xml php74-php-xmlrpc php74-php-mbstring php74-php-soap curl curl-devel
yum -y remove php80-php-cli php80-php-common  php80-php-opcache php80-php-zip php80-php-json php80-php-mbstring php80-php-gettext php80-php-xml php80-php-bcmath php80-php-dba php80-php-dbg php80-php-mysqlnd php80-php-odbc php80-php-gd php80-php-pdo php80-php-gmp php80-php-gd php80-php-ldap php80-php-odbc php80-php-pear php80-php-xml php80-php-xmlrpc php80-php-mbstring php80-php-soap curl curl-devel







systemctl disable  php56-php-fpm php72-php-fpm php73-php-fpm php74-php-fpm php80-php-fpm php80-endurance-fpm
systemctl stop  php56-php-fpm php72-php-fpm php73-php-fpm php74-php-fpm php80-php-fpm php80-endurance-fpm
rm -rf /lib/systemd/system/php80-endurance-fpm.service

rm -rf /opt/remi
rm -rf /etc/opt/remi
rm -rf /etc/endurance/configs/php
rm -rf /var/opt/remi/php80-endurance

# dnf -y module list php
# dnf -y  module disable php:remi-7.2
dnf -y remove php php-cli php-common
yum -y remove php php-cli php-common  php-opcache php-zip php-json php-mbstring php-gettext php-xml php-bcmath php-dba php-dbg php-mysqlnd php-odbc php-gd php-pdo php-gmp php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
php -v
echo "PHP Removed"