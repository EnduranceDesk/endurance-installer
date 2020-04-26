clear
echo "***************************************";
echo "*        Building Endurance DB        *"
echo "***************************************";

mkdir -p /etc/endurance/db
mv /etc/endurance/db/main.db /etc/endurance/db/main.db.backup
cp -v /etc/endurance/repo/EndurancePanel/endurance-installer/misc/endurance_database/standby/main.db /etc/endurance/db/main.db

echo "***************************************";
echo "*         Endurance DB Built          *"
echo "***************************************";