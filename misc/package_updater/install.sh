# @Author: Nawaz Sarwar
# @Date:   2020-04-08 16:30:51
# @Last Modified by:   Adnan
# @Last Modified time: 2020-04-27 02:22:16
echo "Installing EPEL-RELEASE"
yum -y install epel-release
echo "EPEL-RELEASE installed"

echo "Updating system"
yum -y update
echo "System update complete"

echo "Installing Firewall"
yum -y install firewalld
systemctl start firewalld
systemctl enable firewalld
echo "Firewall Installed"

echo "Installing Network tools"
dnf install bind-utils -y
yum install whois -y
echo "Network tools installed"