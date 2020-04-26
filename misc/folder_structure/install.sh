echo "Building Base Folder Structures"

mkdir -p /etc/endurance
mkdir -p /etc/endurance/configs
mkdir -p /etc/endurance/repo
mkdir -p /etc/endurance/current
mkdir -p /etc/endurance/configs
mkdir -p /etc/endurance/configs/server



rm -rf /home/endurance

ln -s /etc/endurance/current/endurance /home/endurance
# ln -s /etc/endurance/current/rover /home/rover

echo "Base Folder Structure Built"