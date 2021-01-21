clear
echo "***************************************";
echo "*         ACME Installing             *"
echo "***************************************";

mkdir -p /etc/endurance/executables
cd /etc/endurance/executables


yum install -y socat
git clone https://github.com/acmesh-official/acme.sh.git
cd ./acme.sh
./acme.sh --install


echo "***************************************";
echo "*         ACME Installed              *"
echo "***************************************";