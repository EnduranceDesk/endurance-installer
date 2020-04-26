# @Author: Nawaz Sarwar
# @Date:   2020-04-08 16:30:51
# @Last Modified by:   Adnan
# @Last Modified time: 2020-04-24 01:26:57
echo "Removing EPEL-RELEASE"
yum -y remove epel-release
echo "EPEL-RELEASE removed"

echo "Updating system"
yum -y update
echo "System update complete"