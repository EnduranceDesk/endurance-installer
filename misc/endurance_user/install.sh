clear
echo "***************************************";
echo "*        Building Endurance User      *"
echo "***************************************";
mkdir /home/endurance
chmod 711 /home/endurance
useradd -m -k -s endurance --home /home/endurance --base-dir /home/endurance  --skel /home/endurance
cp -v /etc/skel/.bash* /home/endurance/
echo "Enter the password for endurance:"
passwd endurance
if [ $? -eq 0 ]; then
    echo "Password for endurance successfully set."
else
    exit 1
fi
chown endurance.endurance /home/endurance

echo "***************************************";
echo "*         Endurance User Built        *"
echo "***************************************";