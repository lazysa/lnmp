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

. /include/main.sh
. /include/init.sh
. /include/download.sh
. /include/version.sh
. /include/mysql.sh  
. /include/apache.sh  
. /include/nginx.sh  
. /include/php.sh  

# Check Current run user is'nt root 
CUID=$(id -u)
if [ "$CUID" -ne 0 ]; then 
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
if [ "$DB_Select" = "1" ]; then
     Check_Mysql ; Install_Mysql_56 
# elif [ "DB_Select" = "2" ]; then 
#	Install_Mysql_55
# elif [ "DB_Select" = "3" ]; then
#	Install_Mysql_51
# elif [ "DB_Select" = "4" ]; then
#	Install_Mariadb_10
fi

if [ "$Apache_Select" = "1" ]; then
     Chenck_Apache ; Install_Apache_24  
# elif [ "Apache_Select" = "2" ]; then 
#	Install_Apache_22 
# elif [ "Apache_Select" = "3" ]; then
#	Install_Apache_24 
fi


if [ "$PHP_Select" = "1" ]; then
       Check_PHP ; Install_PHP_56  
# elif [ "PHP_Select" = "2" ]; then 
#	Install_PHP_55 
# elif [ "PHP_Select" = "3" ]; then
#	Install_PHP_54 
# elif [ "PHP_Select" = "4" ]; then
#	Install_PHP_53 
# elif [ "PHP_Select" = "5" ]; then
#	Install_PHP_52 
fi

}


function DO_LNMP {
#if [ "$DB_Select" = "1" ]; then
#	Check_Mysql ; Install_Mysql_56 
# elif [ "DB_Select" = "2" ]; then 
#	Install_Mysql_55
# elif [ "DB_Select" = "3" ]; then
#	Install_Mysql_51
# elif [ "DB_Select" = "4" ]; then
#	Install_Mariadb_10
#fi


#if [ "$Nginx_Select" = "1" ]; then
	Install_Nginx_18  
# elif [ "Nginx_Select" = "2" ]; then 
#	Install_Nginx_22 
# elif [ "Nginx_Select" = "3" ]; then
#	Install_Nginx_24 
#fi

#if [ "$PHP_Select" = "1" ]; then
#	Check_PHP ; Install_PHP_56  
# elif [ "PHP_Select" = "2" ]; then 
#	Install_PHP_55 
# elif [ "PHP_Select" = "3" ]; then
#	Install_PHP_54 
# elif [ "PHP_Select" = "4" ]; then
#	Install_PHP_53 
# elif [ "PHP_Select" = "5" ]; then
#	Install_PHP_52 
#fi
		
}


function VERSION {

if [ -n "$DBSelect" ]; then 
Mysql_version=`$Mysql_base/mysqld -V |awk '{print $3}'`
else 
    echo -e "============= \033[;31m MySQL no install，exit \033[0m ================="
exit 2
fi


if [ -n "$WebSelect" ]; then 
Apache_version=`$Apache_base/bin/httpd -V |sed -n '1p' |cut -d/ -f2 |awk '{print $1}'`
else 
    echo -e "============= \033[;31m Apache no install，exit \033[0m ================="
exit 2
fi


if [ -n "$PHPSelect" ]; then 
PHP_version=`$PHP_base/bin/php -v  /usr/local/php/bin/php -v |grep "cli" |awk '{print $2}'`
else 
    echo -e "============= \033[;31m PHP no install，exit \033[0m ================="
exit 2
fi


if [ -n "$NginxSelect" ]; then 
Nginx_version=`$Nginx_base/sbin/nginx -v |cut -d/ -f2`
else 
    echo -e "============= \033[;31m Nginx no install，exit \033[0m ================="
exit 2
fi


echo -e "============= \033[;32m  MySQL Version: mysql-$Mysql_version \033[0m ================="
echo -e "============= \033[;32m  Apache Version: httpd-$Apache_version \033[0m ================="
echo -e "============= \033[;32m  PHP Version: php-$PHP_version \033[0m ================="
echo -e "============= \033[;32m  Nginx Version: php-$PHP_version \033[0m ================="

}


#if [ $2 == "auto" ] || [ $2 == "AUTO" ]; then   
#   Auto_Select ; DO_LAMP
#else 
#   Auto_Select ; DO_LNMP
#fi


case $1 in 
    lamp|LAMP)
    	  if [ $2 == "auto" ] || [ $2 == "AUTO" ]; then   
              Auto_Select  
          else 
   	      Display_Select
	  fi

          DO_LAMP #>> /var/log/lamp 2>&1
	  ;;
    lnmp|LNMP)
    	  if [ $2 == "auto" ] || [ $2 == "AUTO" ]; then   
              Auto_Select  
          else 
   	      Display_Select
	  fi

          DO_LNMP #>> /var/log/lnmp 2>&1
	  ;;
    -v|-V)
          VERSION 
	  echo -e "============= \033[;34m List All software Version: \033[0m ================="
#	  echo "${VERSION[@]}"
         ;;
    remove)
         Remove_Mysql ; Remove_Apache ; Remove_PHP ; Remove_Nginx
         ;;

    *)
      echo -e "\033[;31m  Usage: $0 {lamp|lnmp|-v[-V]|remove} [auto] \033[0m "
      exit 2
esac


