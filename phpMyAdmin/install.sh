# @Author: Adnan
# @Date:   2020-04-21 14:32:38
# @Last Modified by:   Adnan
# @Last Modified time: 2021-01-24 09:51:12
clear
echo "***************************************";
echo "*       phpMyAdmin Installing         *"
echo "***************************************";

yum -y install unzip
# wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.zip
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-all-languages.zip
unzip phpMyAdmin-5.0.1-all-languages.zip
rm -rf phpMyAdmin-5.0.1-all-languages.zip
mv phpMyAdmin-5.0.1-all-languages /usr/share/phpmyadmin
mkdir /usr/share/phpmyadmin/tmp
chown -R apache:apache /usr/share/phpmyadmin
chmod 777 /usr/share/phpmyadmin/tmp

cat > /etc/endurance/configs/apollo/conf.d/phpmyadmin.conf << EOF
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
 

EOF

cat > /etc/endurance/configs/discovery/conf.d/phpmyadmin.conf << EOF
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
 

EOF

<FilesMatch ".php$"> 
       SetHandler "proxy:unix:/etc/endurance/configs/php/php80-endurance-fpm/endeavour.sock|fcgi://localhost/"          
</FilesMatch>
   
systemctl restart apollo

echo "***************************************";
echo "*       phpMyAdmin Installed           *"
echo "***************************************";
