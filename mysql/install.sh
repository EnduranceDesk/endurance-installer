# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2021-01-18 01:06:18
clear
echo "***************************************";
echo "*           MySQL Installing           *"
echo "***************************************";

dnf -y install mysql-server

firewall-cmd --permanent --add-port=3306/tcp

systemctl start mysqld.service
systemctl is-active --quiet mysqld && echo MySQL is running.


MYSQLPASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
echo -e $MYSQLPASS  | tr -d '\n' > /etc/endurance/credentials/mysql.root 
mysqladmin -u root password "$MYSQLPASS"
mysql -u root -p"$MYSQLPASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$MYSQLPASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$MYSQLPASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$MYSQLPASS" -e "FLUSH PRIVILEGES"

mysql -u root -p"$MYSQLPASS" << EOF
CREATE DATABASE endurance;
EOF

MYSQL_ENDURANCE_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
echo -e $MYSQL_ENDURANCE_PASS  | tr -d '\n' > /etc/endurance/credentials/mysql.endurance
echo -e $MYSQL_ENDURANCE_PASS  | tr -d '\n' > /home/endurance/mysql.endurance
echo -e $MYSQL_ENDURANCE_PASS  | tr -d '\n' > /home/rover/mysql.endurance
chown -R endurance:endurance /home/endurance/mysql.endurance
chown -R rover:rover /home/rover/mysql.endurance

mysql -u root -p"$MYSQLPASS" << EOF
CREATE USER 'endurance_user'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ENDURANCE_PASS';
EOF

mysql -u root -p"$MYSQLPASS" << EOF
GRANT ALL PRIVILEGES ON endurance.* TO 'endurance_user'@'%';
EOF

mysql -u root -p"$MYSQLPASS" << EOF
ALTER USER 'endurance_user'@'%' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
EOF

systemctl enable mysqld

echo "***************************************";
echo "*           MySQL Installed           *"
echo "***************************************";