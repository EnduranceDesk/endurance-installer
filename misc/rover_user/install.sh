clear
echo "***************************************";
echo "*        Building Rover User          *"
echo "***************************************";
mkdir /home/rover
chmod 711 /home/rover
useradd -m -k -s rover --home /home/endurance --base-dir /home/rover  --skel /home/rover
cp -v /etc/skel/.bash* /home/rover/
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