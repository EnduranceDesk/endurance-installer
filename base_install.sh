#!/bin/bash
clear
cd /etc/endurance/repo/endurance-installer
PWD=$(pwd)
echo "***************************************";
echo "*   INSTALLING BASE ENDURANCE PANEL   *"
echo "***************************************"
echo "CURRENT DIRECTORY: $PWD" 
setenforce 0
cat > /etc/sysconfig/selinux << EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF

chattr -V -i /etc/resolv.conf
cat > /etc/resolv.conf << EOF
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
chattr -V +i /etc/resolv.conf


bash "$PWD/misc/package_updater/install.sh"
clear
bash "$PWD/wget/install.sh"
clear
bash "$PWD/misc/hostname/install.sh"
exitcodeForHostname=$?
clear
if [ $exitcodeForHostname -eq 3 ]; then
    echo "Error: Hostname is not pointed to this server. "
    exit 3;
fi
bash "$PWD/misc/endurance_user/install.sh"
clear
bash "$PWD/misc/rover_user/install.sh"
clear
bash "$PWD/misc/folder_structure/install.sh"
clear
clear
bash "$PWD/misc/endurance_database/install.sh"
clear
bash "$PWD/httpd/install.sh"
clear
bash "$PWD/mysql/install.sh"
clear
bash "$PWD/php/install.sh"
clear
bash "$PWD/phpMyAdmin/install.sh"
clear
bash "$PWD/bind/install.sh"
clear
bash "$PWD/cron/install.sh"
clear
bash "$PWD/acme/install.sh"
clear
bash "$PWD/dkim/install.sh"
clear
bash "$PWD/screen/install.sh"
clear
bash "$PWD/mail/install.sh"
clear
bash "$PWD/composer/install.sh"
clear
bash "$PWD/supervisor/install.sh"
clear
bash "$PWD/node/install.sh"
clear
bash "$PWD/python/install.sh"
clear
echo "*********************************************";
echo "*   BASE ENDURANCE INSTALLATION COMPLETED   *"
echo "*********************************************"
echo "Rebooting in 5 seconds"
sleep 5 ; reboot