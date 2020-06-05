clear
echo "***************************************";
echo "*        Building Endurance User      *"
echo "***************************************";

/usr/sbin/useradd endurance -d /home/endurance  -m  
echo "Enter the password for endurance:"
passwd endurance
if [ $? -eq 0 ]; then
    echo "Password for endurance successfully set."
else
    exit 1
fi


echo "***************************************";
echo "*         Endurance User Built        *"
echo "***************************************";