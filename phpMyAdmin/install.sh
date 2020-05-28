# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 10:16:03
clear
echo "***************************************";
echo "*       phpMyAdmin Installing         *"
echo "***************************************";

yum -y install phpmyadmin

systemctl restart httpd

echo "***************************************";
echo "*       phpMyAdmin Installed           *"
echo "***************************************";