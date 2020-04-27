#!/bin/bash
clear
cd /etc/endurance/repo/EndurancePanel/endurance-installer
PWD=$(pwd)
echo "*********************************************************************************************************************";
echo "***************************************   UNINSTALLING BASE ENDURANCE PANEL   ***************************************"
echo "*********************************************************************************************************************"

echo "CURRENT DIRECTORY: $PWD" 

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Internet Available"
else
    echo "No Internet Available. Aborting."
    exit 1
fi

bash "$PWD/misc/package_updater/rollback.sh"
bash "$PWD/misc/folder_structure/rollback.sh"
bash "$PWD/wget/rollback.sh"
bash "$PWD/httpd/rollback.sh"
bash "$PWD/php/rollback.sh"
bash "$PWD/phpsu/rollback.sh"
bash "$PWD/composer/rollback.sh"
bash "$PWD/supervisor/rollback.sh"
rm -rf /etc/endurance

echo "*********************************************************************************************************************";
echo "************************************   BASE ENDURANCE UNINSTALLATION COMPLETED   ************************************"
echo "*********************************************************************************************************************"