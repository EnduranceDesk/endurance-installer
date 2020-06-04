echo "***************************************";
echo "*           INSTALLING CRON           *"
echo "***************************************"

cat >  /etc/cron.allow << EOF
root
EOF

touch /var/spool/cron/root
/usr/bin/crontab /var/spool/cron/root
crontab -u root -l

echo "***************************************";
echo "*           CRON INSTALLED            *"
echo "***************************************"
