#!/bin/bash
clear
cd /etc/endurance/repo/EndurancePanel/endurance-installer
PWD=$(pwd)
echo "***************************************";
echo "*   INSTALLING BASE ENDURANCE PANEL   *"
echo "***************************************"
echo "CURRENT DIRECTORY: $PWD" 

setenforce 0
bash "$PWD/misc/package_updater/install.sh"
bash "$PWD/wget/install.sh"
clear
bash "$PWD/misc/endurance_user/install.sh"
clear
bash "$PWD/misc/folder_structure/install.sh"
clear
bash "$PWD/misc/endurance_database/install.sh"
clear
bash "$PWD/httpd/install.sh"
clear
bash "$PWD/php/install.sh"
systemctl restart httpd
# bash "$PWD/phpsu/install.sh"
# systemctl restart httpd
clear
bash "$PWD/composer/install.sh"
clear

bash "/etc/endurance/repo/EndurancePanel/deploy_endurance.sh"
bash "/etc/endurance/repo/EndurancePanel/deploy_rover.sh"

echo "*********************************************";
echo "*   BASE ENDURANCE INSTALLATION COMPLETED   *"
echo "*********************************************"