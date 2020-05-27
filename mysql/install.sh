# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 00:32:56
clear
echo "***************************************";
echo "*           MySQL Installing           *"
echo "***************************************";

dnf -y install mysql-server

systemctl start mysqld.service
systemctl is-active --quiet mysql-server && echo MySQL is running.
sudo systemctl enable mysqld

mysql_secure_installation

mysql --user="root"  --database="endurance" --execute="GRANT ALL PRIVILEGES ON *.* TO 'endurance'@'localhost' IDENTIFIED BY 'Endurance!@#';"
mysql --user="endurance" --password="Endurance!@#"  --database="endurance" --execute="CREATE DATABASE endurance;"



echo "***************************************";
echo "*           MySQL Installed           *"
echo "***************************************";