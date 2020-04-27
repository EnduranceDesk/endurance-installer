echo "***************************************";
echo "*        INSTALLING ENDEAVOUR         *"
echo "***************************************"

mkdir -p /etc/endurance/repo
cd /etc/endurance/repo
git clone https://github.com/AdnanHussainTurki/endeavour


mkdir -p /etc/endurance/current
cp -rf /etc/repo/endeavour /etc/current/endeavour

cd /etc/endurance/current/endeavour
sh deploy.sh



echo "***************************************";
echo "*         ENDEAVOUR INSTALLED         *"
echo "***************************************"