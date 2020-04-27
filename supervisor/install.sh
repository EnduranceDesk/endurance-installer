echo "***************************************";
echo "*        INSTALLING SUPERVISOR         *"
echo "***************************************"

yum -y install supervisor
mkdir -p /etc/supervisor.d
mkdir -p /etc/endurance/current/endeavour.supervisor.log
touch /etc/endurance/current/endeavour.supervisor.log/worker.log
touch /etc/supervisor.d/endeavour.ini
cat > /etc/supervisor.d/endeavour.ini << EOF
[program:endeavour-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /etc/endurance/current/endeavour/artisan queue:work  --tries=1
autostart=true
autorestart=true
user=root
numprocs=8
redirect_stderr=true
stdout_logfile=/etc/endurance/current/endeavour.supervisor.log/worker.log
stopwaitsecs=3600
EOF

systemctl start supervisord
if 
systemctl is-active --quiet supervisord
then
echo Supervisor is Up and Running.
else
  echo Supervisor is Down and Not Running.
fi

echo "***************************************";
echo "*         SUPERVISOR INSTALLED         *"
echo "***************************************"