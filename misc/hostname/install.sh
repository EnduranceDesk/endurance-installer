clear
echo "***************************************";
echo "*            Setting Hostname         *"
echo "***************************************";

read -p "Enter your fully qualified hostname (endurance.example.com): "  hostname
if [ -z "$hostname" ]
then
      echo "No host name is provided. Using default."
else
      hostnamectl set-hostname $hostname
fi

echo "***************************************";
echo "*             Hostname Set            *"
echo "***************************************";