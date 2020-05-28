# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 10:16:24
clear
echo "***************************************";
echo "*    phpMyAdmin Uninstalling          *"
echo "***************************************";

yum -y remove phpmyadmin

systemctl restart httpd


echo "***************************************";
echo "*    phpMyAdmin Uninstalled          *"
echo "***************************************";