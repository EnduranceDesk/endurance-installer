clear
echo "***************************************";
echo "*        Building Rover User          *"
echo "***************************************";

/usr/sbin/useradd rover -d /home/rover  -m  -r
chmod 711 /home/rover

ENDEAVOURIP=$(curl -s http://whatismyip.akamai.com/)
echo -e $ENDEAVOURIP  | tr -d '\n' > /home/rover/endeavour.ip
chown rover.rover /home/rover/endeavour.ip

echo "***************************************";
echo "*         Endurance Rover Built        *"
echo "***************************************";