echo "***************************************";
echo "*      UNINSTALLING SUPERVISOR        *"
echo "***************************************"

yum -y remove supervisor
rm -rf /etc/supervisord.conf
rm -rf /etc/supervisord.d

echo "***************************************";
echo "*       SUPERVISOR UNINSTALLED       *"
echo "***************************************"