echo "================"
echo "Removing phpSu"

yum -y groupremove  'Development Tools'
yum -y remove apr-devel
yum -y remove httpd-devel



rm -rf /etc/httpd/conf.d/suphp.conf
rm -rf /etc/endurance/configs/suphp

systemctl restart httpd

echo "phpSu Removed"
echo "==============="