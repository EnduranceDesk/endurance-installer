clear
echo "***************************************";
echo "*        Building Endurance DB        *"
echo "***************************************";

mkdir -p /etc/endurance/db
mv /etc/endurance/db/main.db /etc/endurance/db/main.db.backup
cp -v /etc/endurance/repo/endurance-installer/misc/endurance_database/standby/main.db /etc/endurance/db/main.db
chown endurance.endurance /etc/endurance/db/main.db
chmod 740 /etc/endurance/db/main.db
echo "***************************************";
echo "*         Endurance DB Built          *"
echo "***************************************";