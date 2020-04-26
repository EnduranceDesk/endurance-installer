#!/bin/bash
# @Author: Nawaz Sarwar
# @Date:   2020-04-08 13:46:34
# @Last Modified by:   Nawaz Sarwar
# @Last Modified time: 2020-04-08 15:37:17

# Source https://linuxize.com/post/secure-apache-with-let-s-encrypt-on-centos-7/

yum install mod_ssl openssl

yum install epel-release

yum install certbot

openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

mkdir -p /var/lib/letsencrypt/.well-known
chgrp apache /var/lib/letsencrypt
chmod g+s /var/lib/letsencrypt

touch /etc/httpd/conf.d/letsencrypt.conf

#

touch /etc/httpd/conf.d/ssl-params.conf


systemctl reload httpd


certbot certonly --agree-tos --email admin@example.com --webroot -w /var/lib/letsencrypt/ -d example.com -d www.example.com

cat /etc/letsencrypt/live/example.com/cert.pem /etc/ssl/certs/dhparam.pem >/etc/letsencrypt/live/example.com/cert.dh.pem


## Add vHost 
#
systemctl restart httpd
