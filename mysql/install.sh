# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-31 12:07:46
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
CREATE USER 'endurance_user'@'%' IDENTIFIED WITH mysql_native_password BY 'endurancekapassword';
EOF

echo "Enter root MySql password again:"
mysql -u root -p << EOF
GRANT ALL PRIVILEGES ON `endurance`.* TO 'endurance_user'@'%';
ALTER USER 'endurance_user'@'%' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
EOF

echo "***************************************";
echo "*           MySQL Installed           *"
echo "***************************************";