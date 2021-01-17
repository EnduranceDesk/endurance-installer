clear
echo "***************************************";
echo "*        Building Endurance User      *"
echo "***************************************";

/usr/sbin/useradd endurance -d  /home/endurance  -m   -r
chmod 711 /home/endurance


ENDEAVOURIP=$(curl -s http://whatismyip.akamai.com/)
echo -e $ENDEAVOURIP  | tr -d '\n' > /home/endurance/endeavour.ip
chown endurance.endurance /home/endurance/endeavour.ip

echo "***************************************";
echo "*         Endurance User Built        *"
echo "***************************************";