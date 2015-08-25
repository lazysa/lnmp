 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		install.sh
 #* Description:   
 #* Last modified:	2015-08-21 23:39
 #* *****************************************************************************/
#!/bin/bash
 
LNMP_Ver='1.0' 

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

. include/main.sh
. include/mysql.sh  
. include/apache.sh  
. include/nginx.sh  
. include/php.sh  

# Check Current run user is'nt root 
Curr_uid=`id -u`
if [ "$Curr_uid" -ne 0 ]; then 
	echo -e "============= \033[;31m The bash scripts must be run by the root user，exit \033[0m ================="
	exit 2
fi 

# Check Distro  
Redhat_refile='/etc/redhat-release'
Redhat_distro=`awk '{print $1}' $Redhat_refile`

if [ -e "$Redhat_refile" ]; then 
	DISTRO=$Redhat_distro 
fi


clear
echo "+------------------------------------------------------------------------+"
echo "|          LNMP V${LNMP_Ver} for ${DISTRO} Linux Server, Written by Licess          |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install LNMP/LNMPA/LAMP on Linux       |"
echo "+------------------------------------------------------------------------+"



function DO_LAMP {
if [ "$DBSelect" = "1" ]; then
	Install_Mysql-5.6 
# elif [ "DBSelect" = "2" ]; then 
#	Install_Mysql-5.5
# elif [ "DBSelect" = "3" ]; then
#	Install_Mysql-5.1
fi

if [ "$WebSelect" = "1" ]; then
	Install_Apache-2.4  
# elif [ "WebSelect" = "2" ]; then 
#	Install_Apache-2.2 
# elif [ "WebSelect" = "3" ]; then
#	Install_Apache-2.4 
fi


if [ "$PHPSelect" = "1" ]; then
	Install_PHP-5.6  
# elif [ "PHPSelect" = "2" ]; then 
#	Install_PHP-5.5 
# elif [ "PHPSelect" = "3" ]; then
#	Install_PHP-5.4 
# elif [ "PHPSelect" = "4" ]; then
#	Install_PHP-5.3 
# elif [ "PHPSelect" = "5" ]; then
#	Install_PHP-5.2 
fi

}


function DO_LNMP {
if [ "$DBSelect" = "1" ]; then
	Install_Mysql-5.6 
# elif [ "DBSelect" = "2" ]; then 
#	Install_Mysql-5.5
# elif [ "DBSelect" = "3" ]; then
#	Install_Mysql-5.1
fi


if [ "$NginxSelect" = "1" ]; then
	Install_Nginx-1.8  
# elif [ "WebSelect" = "2" ]; then 
#	Install_Apache-2.2 
# elif [ "WebSelect" = "3" ]; then
#	Install_Apache-2.4 
fi

if [ "$PHPSelect" = "1" ]; then
	Install_PHP-5.6  
# elif [ "PHPSelect" = "2" ]; then 
#	Install_PHP-5.5 
# elif [ "PHPSelect" = "3" ]; then
#	Install_PHP-5.4 
# elif [ "PHPSelect" = "4" ]; then
#	Install_PHP-5.3 
# elif [ "PHPSelect" = "5" ]; then
#	Install_PHP-5.2 
fi
		
}


case $1 in 
	[lamp|LAMP])
		DO_LAMP >> /var/log/lamp 2>&1
	;;
	[lnmp|lnmp]
		DO_LNMP >> /var/log/lnmp 2>&1
	;;
	*)
		echo "Usage: $0 (lamp|lnmp)"
	;;
esac


