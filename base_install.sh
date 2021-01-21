#!/bin/bash
clear
cd /etc/endurance/repo/endurance-installer
PWD=$(pwd)
echo "***************************************";
echo "*   INSTALLING BASE ENDURANCE PANEL   *"
echo "***************************************"
echo "CURRENT DIRECTORY: $PWD" 

cat > /etc/sysconfig/selinux << EOF
SELINUX=disabled
SELINUXTYPE=targeted
EOF

bash "$PWD/misc/package_updater/install.sh"
bash "$PWD/wget/install.sh"
clear
bash "$PWD/misc/endurance_user/install.sh"
clear
bash "$PWD/misc/rover_user/install.sh"
clear
bash "$PWD/misc/folder_structure/install.sh"
clear
bash "$PWD/misc/hostname/install.sh"
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
bash "$PWD/composer/install.sh"
clear
bash "$PWD/supervisor/install.sh"
clear
bash "$PWD/node/install.sh"
clear
echo "*********************************************";
echo "*   BASE ENDURANCE INSTALLATION COMPLETED   *"
echo "*********************************************"
echo "Rebooting in 5 seconds"
sleep 5 ; reboot