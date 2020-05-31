cat >  /etc/cron.allow << EOF
root
EOF

touch /var/spool/cron/root
/usr/bin/crontab /var/spool/cron/root

cat > /var/spool/cron/root << EOF
* * * * * cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
* * * * * sleep 10 && cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
* * * * * sleep 20 && cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
* * * * * sleep 30 && cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
* * * * * sleep 40 && cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
* * * * * sleep 50 && cd /etc/endurance/current/endeavour && php artisan schedule:run >> /dev/null 2>&1
EOF

crontab -u root -l