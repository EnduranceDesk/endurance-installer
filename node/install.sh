clear
echo "***************************************";
echo "*           Node Installing           *"
echo "***************************************";
curl -sL https://rpm.nodesource.com/setup_current.x | sudo bash -
yum -y install nodejs
node --version
npm --version
echo "***************************************";
echo "*            Node Installed           *"
echo "***************************************";