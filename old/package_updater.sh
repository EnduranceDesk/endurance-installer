# @Author: Nawaz Sarwar
# @Date:   2020-04-08 16:30:51
# @Last Modified by:   Adnan Hussain Turki
# @Last Modified time: 2020-04-24 00:02:57
echo "Installing EPEL-RELEASE"
yum install epel-release
echo "EPEL-RELEASE installed"
echo "Updating system"
yum update
echo "System update complete"