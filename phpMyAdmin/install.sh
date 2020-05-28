# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2020-05-28 11:19:12
clear
echo "***************************************";
echo "*       phpMyAdmin Installing         *"
echo "***************************************";

yum -y install unzip
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.zip
unzip phpMyAdmin-5.0.1-all-languages.zip
mv phpMyAdmin-5.0.1-all-languages /usr/share/phpmyadmin
mkdir /usr/share/phpmyadmin/tmp
chown -R apache:apache /usr/share/phpmyadmin
chmod 777 /usr/share/phpmyadmin/tmp

cat > /etc/httpd/conf.d/phpmyadmin.conf << EOF
Alias /phpmyadmin /usr/share/phpmyadmin
 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
 
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
 # Apache 2.4
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOF
chcon -Rv --type=httpd_sys_content_t /usr/share/phpmyadmin/*

systemctl restart httpd

echo "***************************************";
echo "*       phpMyAdmin Installed           *"
echo "***************************************";