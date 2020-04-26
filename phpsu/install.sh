echo "================"
echo "Installing phpSu"

mkdir /etc/endurance/configs/suphp
mkdir /etc/endurance/configs/suphp/logs

yum -y groupinstall 'Development Tools'
yum -y install apr-devel
yum -y install httpd-devel

mkdir temp
cd temp
wget http://suphp.org/download/suphp-0.7.2.tar.gz
tar zxvf suphp-0.7.2.tar.gz

wget -O patchingsuphp.patch https://www.webhostinghero.com/downloads/php/suphp.patch
patch -Np1 -d suphp-0.7.2 < patchingsuphp.patch
cd suphp-0.7.2
autoreconf -if

./configure --prefix=/usr/ --sysconfdir=/etc/ --with-apr=/usr/bin/apr-1-config --with-apache-user=nobody --with-setid-mode=paranoid  --with-logfile=/var/log/httpd/suphp_log  --enable-SUPHP_USE_USERGROUP=yes

make
make install

rm -rf /etc/httpd/conf.d/suphp.conf
touch /etc/httpd/conf.d/suphp.conf

cat > /etc/httpd/conf.d/suphp.conf << EOF
LoadModule suphp_module modules/mod_suphp.so
EOF

rm -rf /etc/suphp.conf
touch /etc/suphp.conf

cat > /etc/suphp.conf << EOF
[global]
;Path to logfile
logfile=/var/log/httpd/suphp.log
;Loglevel
loglevel=info
;User Apache is running as
webserver_user=nobody
;Path all scripts have to be in
docroot=/
;Path to chroot() to before executing script
;chroot=/mychroot
; Security options
allow_file_group_writeable=true
allow_file_others_writeable=false
allow_directory_group_writeable=true
allow_directory_others_writeable=false
;Check wheter script is within DOCUMENT_ROOT
check_vhost_docroot=true
;Send minor error messages to browser
errors_to_browser=false
;PATH environment variable
env_path=/bin:/usr/bin
;Umask to set, specify in octal notation
umask=0077
; Minimum UID
min_uid=100
; Minimum GID
min_gid=100

[handlers]
;Handler for php-scripts
x-httpd-suphp="php:/usr/bin/php-cgi"
;Handler for CGI-scripts
x-suphp-cgi="execute:!self"
EOF


ln -s /etc/suphp.conf /etc/endurance/configs/suphp.conf
ln -s /var/log/httpd/suphp_log /etc/endurance/configs/suphp/logs/suphp_log

systemctl restart httpd

echo "phpSu Installed"
echo "==============="