echo "***************************************";
echo "*        INSTALLING ENDEAVOUR         *"
echo "***************************************"

mkdir -p /etc/endurance/repo
cd /etc/endurance/repo

git clone https://github.com/AdnanHussainTurki/endeavour

rm -rf /etc/endurance/current/endeavour
mkdir -p /etc/endurance/current/endeavour
cp -rf /etc/endurance/repo/endeavour/* /etc/endurance/current/endeavour

cd /etc/endurance/current/endeavour
sh deploy.sh



echo "***************************************";
echo "*         ENDEAVOUR INSTALLED         *"
echo "***************************************"