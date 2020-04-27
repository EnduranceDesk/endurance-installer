echo "***************************************";
echo "*        INSTALLING ENDEAVOUR         *"
echo "***************************************"

mkdir -p /etc/repo
cd /etc/repo
git clone https://github.com/AdnanHussainTurki/endeavour


mkdir -p /etc/current
cp -rf /etc/repo/endeavour /etc/current/endeavour

cd /etc/current/endeavour
sh deploy.sh



echo "***************************************";
echo "*         ENDEAVOUR INSTALLED         *"
echo "***************************************"