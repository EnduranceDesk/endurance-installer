pclear
echo "***************************************";
echo "*        Building Rover User          *"
echo "***************************************";

/usr/sbin/useradd rover -d /home/rover  -m  
echo "Enter the password for rover:"
passwd rover
if [ $? -eq 0 ]; then
    echo "Password for rover successfully set."
else
    exit 1
fi
chown rover.rover /home/rover

echo "***************************************";
echo "*         Endurance Rover Built        *"
echo "***************************************";