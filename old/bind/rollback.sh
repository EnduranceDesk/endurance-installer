echo "Stopping Named"
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

echo "BIND REMOVED"