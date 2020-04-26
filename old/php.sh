#!/bin/bash
# @Author: Nawaz Sarwar
# @Date:   2020-04-08 18:24:42
# @Last Modified by:   Adnan Hussain Turki
# @Last Modified time: 2020-04-21 03:42:17

# STEP 1    Check and display available version for installation
echo ""
echo ""
yum -y install epel-release
rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
echo "Checking PHP version"
yum info php
# Check version requirements

yum -y install yum-utils
yum update

echo "Installing PHP"
yum-config-manager --enable remi-php72
yum -y install php php-opcache
yum -y install php-cli php-zip php-json php-mbstring php-gettext php-xml php-bcmath php-dba php-dbg php-mysqlnd php-odbc php-gd php-pdo php-gmp php-opcache php-gd php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-soap curl curl-devel
echo "php installation successfull"



########### COMPOSER INSTALLATION ###########################
echo "Downloading Composer"
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

echo "Installing Composer"
php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
echo $RESULT

echo "Moving Composer to /usr/local/bin/composer"
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
composer -V


##############
# NOT TESTED / WORKING TILL NOW
#
# wget http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/pam-devel-1.3.1-4.el8.x86_64.rpm
# wget    http://www.nosuchhost.net/~cheese/fedora/packages/epel-7/x86_64/php-pecl-pam-1.0.3-1.el7.x86_64.rpm

# rpm -Uvh pam-devel-1.3.1-4.el8.x86_64.rpm
# rpm -Uvh php-pecl-pam-1.0.3-1.el7.x86_64.rpm