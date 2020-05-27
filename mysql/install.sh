# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-27 23:58:40
clear
echo "***************************************";
echo "*           MySQL Installing           *"
echo "***************************************";

dnf -y install mysql-server

systemctl start mysqld.service
systemctl is-active --quiet mysql-server && echo MySQL is running.
sudo systemctl enable mysqld

mysql_secure_installation

mysql -u root -p
GRANT ALL PRIVILEGES ON *.* TO 'endurance'@'localhost' IDENTIFIED BY 'Endurance!@#';
mysql -u endurance -p
CREATE DATABASE endurance;


echo "***************************************";
echo "*           MySQL Installed           *"
echo "***************************************";