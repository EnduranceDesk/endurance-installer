clear
echo "***************************************";
echo "*            Setting Hostname         *"
echo "***************************************";

read -p "Enter your fully qualified hostname (example.com) - domain should be pointed to this server already: "  hostname
if [ -z "$hostname" ]
then
      echo "No host name is provided. Using default."
else
      hostnamectl set-hostname $hostname
fi

hostip=$(dig +short $hostname)
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)
if [ $hostip ==  $myip ]; then
      echo "SUCCESS: Current server IP and hostname ip matched."
else
      echo "ERROR: IP address of the current server and the hostname provided is not matched. Exiting."
      exit 3
fi

echo "***************************************";
echo "*             Hostname Set            *"
echo "***************************************";