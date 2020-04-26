#!/bin/bash

# @Author: Nawaz Sarwar
# @Date:   2020-04-07 20:51:45
# @Last Modified by:   Nawaz Sarwar
# @Last Modified time: 2020-04-08 14:11:45
clear

ENDURANCE_INSTALLER_VERSION="master"
ENDURANCE_CORE_VERSION="1.0"

PANEL_PATH="/etc/endurance"
PANEL_DATA="/var/endurance"
PANEL_UPGRADE=false

#--- Display the 'welcome' splash/user warning info..
printf "##############################################################################\n"
printf "########################### Hi I am ENDURANCE ################################\n"
printf "##############################################################################\n\n"

echo ""
echo "##############################################################################"
echo "##############################################################################"
echo "#  Welcome to the Official Endurance Installer $ENDURANCE_INSTALLER_VERSION  #"
echo "##############################################################################"
echo "##############################################################################"

echo -e "\nChecking that minimal requirements are ok"

# Ensure the OS is compatible with the launcher
if [ -f /etc/centos-release ]; then
    OS="CentOs"
    VERFULL=$(sed 's/^.*release //;s/ (Fin.*$//' /etc/centos-release)
    VER=${VERFULL:0:1} # return 6 or 7
elif [ -f /etc/lsb-release ]; then
    OS=$(grep DISTRIB_ID /etc/lsb-release | sed 's/^.*=//')
    VER=$(grep DISTRIB_RELEASE /etc/lsb-release | sed 's/^.*=//')
elif [ -f /etc/os-release ]; then
    OS=$(grep -w ID /etc/os-release | sed 's/^.*=//')
    VER=$(grep VERSION_ID /etc/os-release | sed 's/^.*"\(.*\)"/\1/')
 else
    OS=$(uname -s)
    VER=$(uname -r)
fi
ARCH=$(uname -m)

echo "Detected : $OS  $VER  $ARCH"

echo ""
echo "Running OS compatibility diagnostics for Endurance." 
if [[ "$OS" = "CentOs" && ("$VER" = "6" || "$VER" = "7" || "$VER" = "8" ) || 
      "$OS" = "Ubuntu" && ("$VER" = "12.04" || "$VER" = "14.04" ) || 
      "$OS" = "debian" && ("$VER" = "7" || "$VER" = "8" ) ]] ; then
    echo "OS compatibility checks passed."
else
    echo "Sorry, this OS is not supported by Endurance." 
    exit 1
fi

# Centos uses repo directory that depends of architecture. Ensure it is compatible
if [[ "$OS" = "CentOs" ]] ; then
    if [[ "$ARCH" == "i386" || "$ARCH" == "i486" || "$ARCH" == "i586" || "$ARCH" == "i686" ]]; then
        ARCH="i386"
    elif [[ "$ARCH" != "x86_64" ]]; then
        echo "Unexpected architecture name was returned ($ARCH ). :-("
        echo "The installer have been designed for i[3-6]8- and x86_64' architectures. If you"
        echo " think it may work on your, please report it to the Sentora forum or bugtracker."
        exit 1
    fi
fi

# Check if the user is 'root' before allowing installation to commence
if [ $UID -ne 0 ]; then
    echo "Install failed: you must be logged in as 'root' to install."
    echo "Use command 'sudo -i', then enter root password and then try again."
    exit 1
else
    echo "Root user confirmed"
fi

# Check for some common control panels that we know will affect the installation/operating of Sentora.
if [ -e /usr/local/cpanel ] || [ -e /usr/local/directadmin ] || [ -e /usr/local/solusvm/www ] || [ -e /usr/local/home/admispconfig ] || [ -e /usr/local/lxlabs/kloxo ] ; then
    echo "It appears that a control panel is already installed on your server; This installer"
    echo "is designed to install and configure Sentora on a clean OS installation only."
    echo -e "\nPlease re-install your OS before attempting to install using this script."
    exit 1
else
    echo "No previous installation of other web-hosting panel found"
fi





















# Check for some common packages that we know will affect the installation/operating of Sentora.
if [[ "$OS" = "CentOs" ]] ; then
    PACKAGE_INSTALLER="yum -y -q install"
    PACKAGE_REMOVER="yum -y -q remove"

    inst() {
       rpm -q "$1" &> /dev/null
    }

    if  [[ "$VER" = "7" || "$VER" > "7" ]]; then
        DB_PCKG="mariadb" &&  echo "DB server will be mariaDB"
    else 
        DB_PCKG="mysql" && echo "DB server will be mySQL"
    fi
    HTTP_PCKG="httpd"
    PHP_PCKG="php"
    BIND_PCKG="bind"
elif [[ "$OS" = "Ubuntu" || "$OS" = "debian" ]]; then
    PACKAGE_INSTALLER="apt-get -yqq install"
    PACKAGE_REMOVER="apt-get -yqq remove"

    inst() {
       dpkg -l "$1" 2> /dev/null | grep '^ii' &> /dev/null
    }
    
    DB_PCKG="mysql-server"
    HTTP_PCKG="apache2"
    PHP_PCKG="apache2-mod-php5"
    BIND_PCKG="bind9"
fi