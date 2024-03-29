# @Author: Adnan
# @Date:   2020-04-18 13:46:52
# @Last Modified by:   Adnan
# @Last Modified time: 2020-06-04 21:26:28

clear
echo "***************************************";
echo "*      DNS Server Installing           *"
echo "***************************************";

yum -y install bind bind-utils

systemctl start named

systemctl enable named

systemctl is-active --quiet named && echo Bind is running.

echo "Adding Bind ports throug firewall"
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --reload
firewall-cmd --zone=public --add-service=dns --permanent


mkdir /etc/endurance/configs/bind
mkdir /etc/endurance/configs/bind/zones
cp  -r -v /etc/named.root.key /etc/endurance/configs/bind/named.root.key
cp  -r -v /etc/named.rfc1912.zones /etc/endurance/configs/bind/named.rfc1912.zones


cp  -r -v /etc/endurance/repo/endurance-installer/bind/includes/acl.conf /etc/endurance/configs/bind/acl.conf
cp  -r -v /etc/endurance/repo/endurance-installer/bind/includes/hint_zone.conf /etc/endurance/configs/bind/hint_zone.conf
cp  -r -v /etc/endurance/repo/endurance-installer/bind/includes/logging.conf /etc/endurance/configs/bind/logging.conf
cp -r -v /etc/endurance/repo/endurance-installer/bind/includes/options.conf /etc/endurance/configs/bind/options.conf
cp  -r -v /etc/endurance/repo/endurance-installer/bind/includes/mynamed.conf /etc/endurance/configs/bind/mynamed.conf
cp  -r -v /etc/endurance/repo/endurance-installer/bind/includes/zones.conf /etc/endurance/configs/bind/zones.conf

cp  -r -v /etc/endurance/repo/endurance-installer/bind/standby/named.conf /etc/named.conf


# chroot 640 /etc/named.conf
chown root:named /etc/named.conf

# chroot 640 /etc/endurance/configs/bind/*
chown root:named /etc/endurance/configs/bind/*

restorecon -v /etc/endurance/configs/bind/*
restorecon -v /etc/named.conf


echo "Checking Bind Configuration Integrity"
named-checkconf

systemctl restart named.service
systemctl restart firewalld.service

if 
systemctl is-active --quiet named
then
echo DNS is Up and Running.
else
  echo DNS is Down and Not Running.
fi
echo "***************************************";
echo "*      DNS Server Installed           *"
echo "***************************************";