echo "Installing Mail Server"
yum install postfix dovecot dovecot-mysql postfix-mysql -y
yum -y install cyrus-sasl
systemctl start postfix dovecot
systemctl enable postfix dovecot

MYSQLPASS=$(cat /etc/endurance/credentials/mysql.root)
MYSQL_MAIL_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
echo -e $MYSQL_MAIL_PASS  | tr -d '\n' > /etc/endurance/credentials/mysql.mailuser


mysql -u root -p"$MYSQLPASS" << EOF
CREATE USER 'endurance_mail_user'@'%' IDENTIFIED WITH mysql_native_password BY '$MYSQL_MAIL_PASS';
EOF

mysql -u root -p"$MYSQLPASS" << EOF
GRANT SELECT ON  endurance.* TO 'endurance_mail_user'@'%';
EOF

mysql -u root -p"$MYSQLPASS" << EOF
ALTER USER 'endurance_mail_user'@'%' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
EOF

mysql -u root -p"$MYSQLPASS" << EOF
FLUSH PRIVILEGES;
EOF

mysql -u root -p"$MYSQLPASS" << EOF

EOF


hostname=$(hostname)
postconf -e "myhostname = $hostname"
postconf -e "mydomain = $hostname"
postconf -e 'myorigin = $mydomain'
postconf -e "inet_interfaces = all"
postconf -e "mydestination = localhost, localhost.localdomain"
postconf -e "mynetworks = 127.0.0.0/8"
# relayhost
postconf -e "relayhost = "
postconf -e "alias_maps = hash:/etc/aliases"
postconf -e "alias_database = hash:/etc/aliases"

postconf -e "recipient_delimiter = +"
postconf -e 'smtpd_banner = $myhostname ESMTP $mail_name'


postconf -e "biff = no"


postconf -e "append_dot_mydomain = no"
postconf -e "readme_directory = no"
postconf -e "message_size_limit = 52400000"
postconf -e "smtpd_sasl_type = dovecot"
postconf -e "smtpd_sasl_path = private/auth"
postconf -e "smtpd_sasl_auth_enable = yes"
postconf -e "broken_sasl_auth_clients = yes"
postconf -e "smtpd_sasl_authenticated_header = yes"
postconf -e "virtual_transport = lmtp:unix:private/dovecot-lmtp"
postconf -e "smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated permit_inet_interfaces reject_unauth_destination"
postconf -e "virtual_alias_domains = "
postconf -e "virtual_alias_maps = proxy:mysql:/etc/postfix/mysql-virtual_forwardings.cf, mysql:/etc/postfix/mysql-virtual_email2email.cf"
postconf -e "virtual_mailbox_domains = proxy:mysql:/etc/postfix/mysql-virtual_domains.cf"
postconf -e "virtual_mailbox_maps = proxy:mysql:/etc/postfix/mysql-virtual_mailboxes.cf"
postconf -e "virtual_mailbox_base = /home/vmail"
postconf -e "virtual_uid_maps = static:5000"
postconf -e "virtual_gid_maps = static:5000"
postconf -e "virtual_create_maildirsize = yes"
postconf -e "virtual_maildir_extended = yes"
postconf -e 'proxy_read_maps = $local_recipient_maps $mydestination $virtual_alias_maps $virtual_alias_domains $virtual_mailbox_maps $virtual_mailbox_domains $relay_recipient_maps $relay_domains $canonical_maps $sender_canonical_maps $recipient_canonical_maps $relocated_maps $transport_maps $mynetworks $virtual_mailbox_limit_maps'

cat > /etc/postfix/mysql-virtual_domains.cf << EOF
user = endurance_mail_user
password = $MYSQL_MAIL_PASS
dbname = endurance
query = SELECT name FROM domains WHERE name='%s'
hosts = 127.0.0.1
EOF

cat > /etc/postfix/mysql-virtual_forwardings.cf << EOF
user = endurance_mail_user
password = $MYSQL_MAIL_PASS
dbname = endurance
query = SELECT destination_emails FROM mail_aliases WHERE source_email='%s' 
hosts = 127.0.0.1
EOF

cat > /etc/postfix/mysql-virtual_mailboxes.cf << EOF
user = endurance_mail_user
password = $MYSQL_MAIL_PASS
dbname = endurance
query = SELECT CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/') FROM mail_users WHERE email='%s' AND active=1
hosts = 127.0.0.1
EOF

cat > /etc/postfix/mysql-virtual_email2email.cf << EOF
user = endurance_mail_user
password = $MYSQL_MAIL_PASS
dbname = endurance
query = SELECT email FROM mail_users WHERE email='%s' AND active=1
hosts = 127.0.0.1
EOF

chmod o= /etc/postfix/mysql-virtual_*
chgrp postfix /etc/postfix/mysql-virtual_*

postmap -q $hostname mysql:/etc/postfix/mysql-virtual_domains.cf 
postmap -q grp-it@$hostname mysql:/etc/postfix/mysql-virtual_forwardings.cf 
postmap -q nawaz@$hostname mysql:/etc/postfix/mysql-virtual_forwardings.cf 
postmap -q nawaz@$hostname mysql:/etc/postfix/mysql-virtual_mailboxes.cf 


groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /home/vmail  -m

echo 'dovecot   unix  -       n       n       -       -       pipe     flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/deliver -f ${sender} -d ${recipient}' >> /etc/postfix/master.cf 

systemctl restart postfix

firewall-cmd --permanent --add-service=smtp
firewall-cmd --reload

echo 'protocols = imap pop3 lmtp' >> /etc/dovecot/dovecot.conf
echo 'listen = *' >> /etc/dovecot/dovecot.conf

echo 'mail_location = maildir:/home/vmail/%d/%n/Maildir' >> /etc/dovecot/conf.d/10-mail.conf
echo 'mail_privileged_group = mail' >> /etc/dovecot/conf.d/10-mail.conf
echo 'disable_plaintext_auth = no' >> /etc/dovecot/conf.d/10-auth.conf
echo 'auth_mechanisms = plain login' >> /etc/dovecot/conf.d/10-auth.conf
echo '!include auth-sql.conf.ext' >> /etc/dovecot/conf.d/10-auth.conf

cat > /etc/dovecot/conf.d/auth-sql.conf.ext << EOF
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = static
  args = uid=5000 gid=5000 home=/home/vmail/%d/%n allow_all_users=yes
}
EOF


# Add password scheme
cat > /etc/dovecot/dovecot-sql.conf.ext << EOF
driver = mysql
connect = host=127.0.0.1 dbname=endurance user=endurance_mail_user password=$MYSQL_MAIL_PASS
default_pass_scheme = SHA512-CRYPT
password_query = SELECT email as User, password FROM mail_users WHERE email='%u' AND active=1;
EOF

chgrp dovecot /etc/dovecot/dovecot-sql.conf.ext
chmod o= /etc/dovecot/dovecot-sql.conf.ext


cat > /etc/dovecot/conf.d/10-master.conf << EOF


service imap-login {
    inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    
  }

}

service pop3-login {
    inet_listener pop3 {
    port = 110
  }
  inet_listener pop3s {
    
  }
}

service submission-login {
  inet_listener submission {
    
  }
}

service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
        mode = 0660
        user = postfix
        group = postfix
  }

}

service imap {
  
}

service pop3 {
  
}

service submission {
  
}

service auth {
  
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
  }
  unix_listener /var/spool/postfix/private/auth {
      mode = 0660
      user = postfix
      group = postfix
  }
  user = dovecot
}

service auth-worker {
  
  user = vmail
}

service dict {
  
  unix_listener dict {
    
  }
}

EOF

# Subject to change in Part 6
echo 'ssl = no' > /etc/dovecot/conf.d/10-ssl.conf
systemctl restart postfix dovecot
firewall-cmd --permanent --add-service=pop3
firewall-cmd --reload

cd /etc/endurance/current
wget https://github.com/roundcube/roundcubemail/releases/download/1.4.9/roundcubemail-1.4.9-complete.tar.gz
mv roundcubemail-1.4.9-complete.tar.gz roundcube.tar.gz
tar xvf roundcube.tar.gz
rm -f roundcube.tar.gz
mv roundcubemail-1.4.9 roundcube

MYSQLPASS=$(cat /etc/endurance/credentials/mysql.root)
MYSQL_ROUNDCUBE_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '')
echo -e $MYSQL_ROUNDCUBE_PASS  | tr -d '\n' > /etc/endurance/credentials/mysql.roundcube

mysql -u root -p"$MYSQLPASS" << EOF
    CREATE DATABASE roundcube DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
EOF
mysql -u root -p"$MYSQLPASS" << EOF
    CREATE USER 'roundcubeuser'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROUNDCUBE_PASS';
EOF
mysql -u root -p"$MYSQLPASS" << EOF
    GRANT ALL PRIVILEGES ON roundcube.* TO roundcubeuser@localhost;
EOF
mysql -u root -p"$MYSQLPASS" << EOF
    flush privileges;
EOF

mysql -u root -p"$MYSQLPASS"  roundcube < /etc/endurance/current/roundcube/SQL/mysql.initial.sql


MYSQL_ROUNDCUBE_PASS=$(cat /etc/endurance/credentials/mysql.roundcube)
config='$config'
cat > /etc/endurance/current/roundcube/config/config.inc.php  << EOD
<?php
$config['db_dsnw'] = 'mysql://roundcubeuser:$MYSQL_ROUNDCUBE_PASS@localhost/roundcube';
$config['smtp_port'] = 465;
$config['default_host'] = "localhost";
$config['smtp_server'] = "ssl://$hostname";
$config['support_url'] = '';
$config['des_key'] = 'fTl91sIRDuIxraKEz48RdWau';
$config['product_name'] = 'Endurance Webmail';
$config['plugins'] = array('emoticons', 'archive', 'jqueryui', 'markasjunk', 'zipdownload');
?>
EOD


# SSL
hostname=$(hostname)
mkdir -p /etc/endurance/configs/ssl/$hostname
openssl genrsa -des3 --passout pass:Endurance -out $hostname.key 2048
openssl req -new -passin pass:Endurance -key $hostname.key -subj "/C=GB/ST=London/L=London/O=Endurance Control Panel/OU=IT Department/CN=$hostname"  -out $hostname.csr
openssl x509 -req --passin  pass:Endurance -days 365 -in $hostname.csr -signkey $hostname.key -out $hostname.cer
openssl rsa --passin pass:Endurance  -in $hostname.key -out $hostname.key.nopass
mv -f $hostname.key.nopass $hostname.key
openssl req -new -x509 -extensions v3_ca -passout pass:Endurance -subj "/C=GB/ST=London/L=London/O=Endurance Control Panel/OU=IT Department/CN=$hostname"  -keyout cakey.pem -out cacert.pem -days 3650 
chmod 600 $hostname.key
chmod 600 cakey.pem
mv $hostname.key /etc/endurance/configs/ssl/$hostname
mv $hostname.cer /etc/endurance/configs/ssl/$hostname
mv cakey.pem /etc/endurance/configs/ssl/$hostname
mv cacert.pem /etc/endurance/configs/ssl/$hostname





postconf -e "smtpd_use_tls = yes"
postconf -e "smtpd_tls_auth_only = yes"
postconf -e "smtp_tls_security_level = may"
postconf -e "smtpd_tls_security_level = may"
postconf -e "smtpd_tls_cert_file = /etc/endurance/configs/ssl/$hostname/$hostname.cer"
postconf -e "smtpd_tls_key_file = /etc/endurance/configs/ssl/$hostname/$hostname.key"
postconf -e "smtpd_sasl_security_options = noanonymous, noplaintext"
postconf -e "smtpd_sasl_tls_security_options = noanonymous"
postconf -e "tls_server_sni_maps = hash:/etc/postfix/vmail_ssl.map"



cat >  /etc/postfix/vmail_ssl.map  << EOD
$hostname /etc/endurance/configs/ssl/$hostname/$hostname.key /etc/endurance/configs/ssl/$hostname/$hostname.cer

EOD

postmap -F hash:/etc/postfix/vmail_ssl.map
systemctl restart postfix

cat >  /etc/postfix/master.cf  << EOD
#
# Postfix master process configuration file.  For details on the format
# of the file, see the master(5) manual page (command: "man 5 master" or
# on-line: http://www.postfix.org/master.5.html).
#
# Do not forget to execute "postfix reload" after editing this file.
#
# ==========================================================================
# service type  private unpriv  chroot  wakeup  maxproc command + args
#               (yes)   (yes)   (no)    (never) (100)
# ==========================================================================
smtp      inet  n       -       n       -       -       smtpd
#smtp      inet  n       -       n       -       1       postscreen
#smtpd     pass  -       -       n       -       -       smtpd
#dnsblog   unix  -       -       n       -       0       dnsblog
#tlsproxy  unix  -       -       n       -       0       tlsproxy
submission inet n       -       n       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth
  -o smtpd_reject_unlisted_recipient=no
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING

smtps     inet  n       -       n       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_sasl_type=dovecot
  -o smtpd_sasl_path=private/auth
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
#628       inet  n       -       n       -       -       qmqpd
pickup    unix  n       -       n       60      1       pickup
cleanup   unix  n       -       n       -       0       cleanup
qmgr      unix  n       -       n       300     1       qmgr
#qmgr     unix  n       -       n       300     1       oqmgr
tlsmgr    unix  -       -       n       1000?   1       tlsmgr
rewrite   unix  -       -       n       -       -       trivial-rewrite
bounce    unix  -       -       n       -       0       bounce
defer     unix  -       -       n       -       0       bounce
trace     unix  -       -       n       -       0       bounce
verify    unix  -       -       n       -       1       verify
flush     unix  n       -       n       1000?   0       flush
proxymap  unix  -       -       n       -       -       proxymap
proxywrite unix -       -       n       -       1       proxymap
smtp      unix  -       -       n       -       -       smtp
relay     unix  -       -       n       -       -       smtp
        -o syslog_name=postfix/$service_name
#       -o smtp_helo_timeout=5 -o smtp_connect_timeout=5
showq     unix  n       -       n       -       -       showq
error     unix  -       -       n       -       -       error
retry     unix  -       -       n       -       -       error
discard   unix  -       -       n       -       -       discard
local     unix  -       n       n       -       -       local
virtual   unix  -       n       n       -       -       virtual
lmtp      unix  -       -       n       -       -       lmtp
anvil     unix  -       -       n       -       1       anvil
scache    unix  -       -       n       -       1       scache
postlog   unix-dgram n  -       n       -       1       postlogd
#
# ====================================================================
# Interfaces to non-Postfix software. Be sure to examine the manual
# pages of the non-Postfix software to find out what options it wants.
#
# Many of the following services use the Postfix pipe(8) delivery
# agent.  See the pipe(8) man page for information about ${recipient}
# and other message envelope options.
# ====================================================================
#
# maildrop. See the Postfix MAILDROP_README file for details.
# Also specify in main.cf: maildrop_destination_recipient_limit=1
#
#maildrop  unix  -       n       n       -       -       pipe
#  flags=DRXhu user=vmail argv=/usr/local/bin/maildrop -d ${recipient}
#
# ====================================================================
#
# Recent Cyrus versions can use the existing "lmtp" master.cf entry.
#
# Specify in cyrus.conf:
#   lmtp    cmd="lmtpd -a" listen="localhost:lmtp" proto=tcp4
#
# Specify in main.cf one or more of the following:
#  mailbox_transport = lmtp:inet:localhost
#  virtual_transport = lmtp:inet:localhost
#
# ====================================================================
#
# Cyrus 2.1.5 (Amos Gouaux)
# Also specify in main.cf: cyrus_destination_recipient_limit=1
#
#cyrus     unix  -       n       n       -       -       pipe
#  flags=DRX user=cyrus argv=/usr/lib/cyrus-imapd/deliver -e -r ${sender} -m ${extension} ${user}
#
# ====================================================================
#
# Old example of delivery via Cyrus.
#
#old-cyrus unix  -       n       n       -       -       pipe
#  flags=R user=cyrus argv=/usr/lib/cyrus-imapd/deliver -e -m ${extension} ${user}
#
# ====================================================================
#
# See the Postfix UUCP_README file for configuration details.
#
#uucp      unix  -       n       n       -       -       pipe
#  flags=Fqhu user=uucp argv=uux -r -n -z -a$sender - $nexthop!rmail ($recipient)
#
# ====================================================================
#
# Other external delivery methods.
#
#ifmail    unix  -       n       n       -       -       pipe
#  flags=F user=ftn argv=/usr/lib/ifmail/ifmail -r $nexthop ($recipient)
#
#bsmtp     unix  -       n       n       -       -       pipe
#  flags=Fq. user=bsmtp argv=/usr/local/sbin/bsmtp -f $sender $nexthop $recipient
#
#scalemail-backend unix -       n       n       -       2       pipe
#  flags=R user=scalemail argv=/usr/lib/scalemail/bin/scalemail-store
#  ${nexthop} ${user} ${extension}
#
#mailman   unix  -       n       n       -       -       pipe
#  flags=FRX user=list argv=/usr/lib/mailman/bin/postfix-to-mailman.py
#  ${nexthop} ${user}
dovecot   unix  -       n       n       -       -       pipe     flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/deliver -f ${sender} -d ${recipient}
EOD


cat > /etc/dovecot/conf.d/10-master.conf << EOF


service imap-login {
    inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    port = 993
    ssl = yes
  }

}

service pop3-login {
    inet_listener pop3 {
    port = 110
  }
  inet_listener pop3s {
    port = 995
    ssl = yes
  }
}

service submission-login {
  inet_listener submission {
    
  }
}

service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
        mode = 0660
        user = postfix
        group = postfix
  }

}

service imap {
  
}

service pop3 {
  
}

service submission {
  
}

service auth {
  
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
  }
  unix_listener /var/spool/postfix/private/auth {
      mode = 0660
      user = postfix
      group = postfix
  }
  user = dovecot
}

service auth-worker {
  
  user = vmail
}

service dict {
  
  unix_listener dict {
    
  }
}

EOF

cat > /etc/dovecot/conf.d/10-ssl.conf << EOF
ssl = required
ssl_cert = </etc/endurance/configs/ssl/$hostname/$hostname.cer
ssl_key = </etc/endurance/configs/ssl/$hostname/$hostname.key
EOF

echo 'disable_plaintext_auth = yes' >> /etc/dovecot/conf.d/10-auth.conf
systemctl restart dovecot

firewall-cmd --permanent --add-service=smtps
firewall-cmd --permanent --add-service=pop3s
firewall-cmd --reload



# DKIM
yum install opendkim -y
opendkim-default-keygen
hostname=$(hostname)
cat > /etc/opendkim.conf << EOF
PidFile /run/opendkim/opendkim.pid
Mode    sv
Syslog  yes
SyslogSuccess   yes
LogWhy  yes
UserID  opendkim:opendkim
Socket  inet:8891@127.0.0.1
Umask   022
SendReports     yes
SoftwareHeader  yes
Canonicalization        relaxed/simple
Domain        $hostname
Selector        default
MinimumKeyBits  1024
KeyTable      refile:/etc/opendkim/KeyTable
SigningTable  refile:/etc/opendkim/SigningTable
ExternalIgnoreList    refile:/etc/opendkim/TrustedHosts
InternalHosts refile:/etc/opendkim/TrustedHosts
OversignHeaders From
EOF

cat > /etc/opendkim/KeyTable << EOF
EOF

cat > /etc/opendkim/SigningTable << EOF
EOF

cat > /etc/opendkim/TrustedHosts << EOF
127.0.0.1
$hostname
mail.$hostname
EOF

postconf -e "smtpd_milters = inet:127.0.0.1:8891"
postconf -e 'non_smtpd_milters = $smtpd_milters'
postconf -e 'milter_default_action = accept'

systemctl restart postfix
systemctl start opendkim
systemctl enable opendkim

cat /etc/opendkim/keys/default.txt



