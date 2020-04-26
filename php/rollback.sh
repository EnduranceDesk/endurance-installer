# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-04-24 01:57:01
echo "Removing PHP"
dnf -y remove https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
rpm -qa | grep epel
dnf -y remove https://rpms.remirepo.net/enterprise/remi-release-8.rpm
rpm -qa | grep remi

# dnf -y module list php
# dnf -y  module disable php:remi-7.2
dnf -y remove php php-cli php-common
yum -y remove php php-cli php-common  php-opcache php-zip php-json php-mbstring php-gettext php-xml php-bcmath php-dba php-dbg php-mysqlnd php-odbc php-gd php-pdo php-gmp php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
php -v
echo "PHP Removed"