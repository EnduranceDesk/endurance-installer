# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-06-04 20:58:48
clear
echo "***************************************";
echo "*    phpMyAdmin Uninstalling          *"
echo "***************************************";

yum -y remove phpmyadmin

systemctl restart httpd


echo "***************************************";
echo "*    phpMyAdmin Uninstalled          *"
echo "***************************************";