echo "***************************************";
echo "*      UNINSTALLING SUPERVISOR        *"
echo "***************************************"

yum -y remove supervisor
rm -rf /etc/supervisord.conf


echo "***************************************";
echo "*       SUPERVISOR UNINSTALLED       *"
echo "***************************************"