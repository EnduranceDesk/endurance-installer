# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 12:28:46
clear
echo "***************************************";
echo "*          DNS Uninstalling           *"
echo "***************************************";

systemctl stop named
systemctl is-active --quiet named && echo Bind is still running.

echo "Uninstalling Named"
yum remove bind bind-utils -y

echo "Removing Bind ports from firewall"
firewall-cmd --permanent --remove-port=53/tcp
firewall-cmd --permanent --remove-port=53/udp
firewall-cmd --reload
firewall-cmd --zone=public --remove-service=dns --permanent

rm -rf /etc/endurance/configs/bind


echo "***************************************";
echo "*          DNS   Uninstalled           *"
echo "***************************************";