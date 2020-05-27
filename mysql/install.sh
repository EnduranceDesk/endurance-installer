# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 01:40:21
clear
echo "***************************************";
echo "*           MySQL Installing           *"
echo "***************************************";

dnf -y install mysql-server

firewall-cmd --permanent --add-port=3306/tcp

systemctl start mysqld.service
systemctl is-active --quiet mysqld && echo MySQL is running.
systemctl enable mysqld

mysql_secure_installation

echo "Enter root MySQL password:"
mysql -u root -p << EOF
CREATE DATABASE endurance;
CREATE USER endurance@localhost IDENTIFIED BY endurancekapassword;
GRANT ALL PRIVILEGES ON endurance.* TO endurance@localhost;
EOF


echo "***************************************";
echo "*           MySQL Installed           *"
echo "***************************************";