# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2021-01-24 09:47:32
clear
echo "***************************************";
echo "*    phpMyAdmin Uninstalling          *"
echo "***************************************";

yum -y remove phpmyadmin
rm -rf /usr/share/phpmyadmin
rm -rf /etc/endurance/configs/apollo/conf.d/phpmyadmin.conf

systemctl restart apollo


echo "***************************************";
echo "*    phpMyAdmin Uninstalled          *"
echo "***************************************";