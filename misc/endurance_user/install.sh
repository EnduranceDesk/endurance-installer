clear
echo "***************************************";
echo "*        Building Endurance User      *"
echo "***************************************";
mkdir /home/endurance
chmod 711 /home/endurance
useradd -m endurance --home /home/endurance
echo "Enter the password for endurance:"
passwd endurance
chown endurance.endurance endurance

echo "***************************************";
echo "*         Endurance User Built        *"
echo "***************************************";