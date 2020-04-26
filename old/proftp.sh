# @Author: Nawaz Sarwar
# @Date:   2020-04-08 16:51:58
# @Last Modified by:   Nawaz Sarwar
# @Last Modified time: 2020-04-08 21:26:52

# STEP 1    Check and display available version for installation
echo ""
echo ""
echo "Checking proftp version"
yum info proftpd
# Check version requirements

echo "Installing proftpd........."
yum -y install proftpd proftpd-mysql
echo "proftpd installation successfull"

echo "Starting proftpd"
systemctl start proftpd

echo "Make sure that proftpd starts at Boot"
systemctl enable proftpd

echo "Checking status of proftpd"
# systemctl status proftpd

echo "Adding proftpd ports throug firewall"
firewall-cmd --permanent --add-port=21/tcp

# Reload the firewall to take effect
firewall-cmd --reload

firewall-cmd --zone=public --add-service=ftp --permanent
systemctl restart firewalld.service 