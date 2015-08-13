 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		init.sh
 #* Description:  init install environment  
 #* Last modified:	2015-08-12 18:51
 #* *****************************************************************************/
#!/bin/bash
 

if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
    echo "Already add aliyum repos, nothing"
else

    # Add Aliyun_mirrors
    OS_version=`cat /etc/redhat-release |awk '{print $3}' |awk -F. '{print $1'}`
    Url_5='http://mirrors.aliyun.com/repo/Centos-5.repo'
    Url_6='http://mirrors.aliyun.com/repo/Centos-6.repo'
    Url_7='http://mirrors.aliyun.com/repo/Centos-7.repo'

    cd /etc/yum.repos.d
	
    # Backup default repos 
    mv CentOS-Base.repo CentOS-Base.repo.bak

    if [ "$OS_version" == "5" ]; then 
         wget -O CentOS-Base.repo $Url_5
    elif [ "$OS_version" == "6" ]; then
         wget -O CentOS-Base.repo $Url_6
    elif [ "$OS_version" == "7" ]; then
         wget -O CentOS-Base.repo $Url_7
    fi

    # Clean yum_cache
    yum clean all
    # Make yum_cache
    yum makecache 

fi


function Check_Mysql {
# Remove Pre-Built ( yum ) version or others source version 
# Check Mysql is install, remove Pre-Built version

rpm -qa mysql |grep mysql
if [ $? -eq 0 ]; then
        echo "Removing Mysql..."
        yum remove mysql -y

elif [ -d /usr/local/mysql/ ]; then
         echo "Mysql already installed by Sources"
         read -p "Enter old 'Mysql Sources dir', (eg: /opt/downloads/mysql-5.6.21/:  )    " Mysql_old_dir
         echo "Removing Mysql..."
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  mysql/
fi
}


function Check_Apache  {
# Check Apache is install, remove Pre-Built version
rpm -qa httpd |grep httpd
if [ $? -eq 0 ]; then
        echo "Removing Apache..."
        yum remove httpd -y

elif [ -d /usr/local/apache/ ]; then
         echo "Apache already installed by Sources"
         read -p "Enter old 'Apache Sources dir', (eg: /opt/downloads/httpd-2.4.12/:   )    " Apache_old_dir
         echo "Removing Apache..."
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr apache/
fi
}


function Check_PHP {
# Check PHP is install, remove Pre-Built version
rpm -qa php |grep php
if [ $? -eq 0 ]; then
        echo "Removing PHP..."
        yum remove php -y

elif [ -d /usr/local/php/ ]; then
         echo "Php already installed by Sources"
         read -p "Enter old 'PHP Sources dir', (eg: /opt/downloads/php5.3.3/:    )" PHP_old_dir
         echo "Removing PHP..."
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  php/
fi
}


