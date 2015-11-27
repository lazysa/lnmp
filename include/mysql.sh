 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		mysql.sh
 #* Description:   Auto-Install script for the MySQL Server
 #* Last modified:	2015-08-21 15:30
 #* *****************************************************************************/
#!/bin/bash
 
 
function Check_Mysql {
# Check Mysql is or not install, remove installed version
# Remove Pre-Built ( yum ) version or others source version 

clear 
echo -e "============= \033[;34m Begin MySQL_install Check \033[0m ================="

rpm -qa |grep -oP "^mysql-server-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed MySQL via yum is detected, Removing MySQL ... \033[0m"
        yum remove mysql -y

elif [ -d "$Mysql_base" ] || [ -d "/opt/mysql" ]; then
         echo -e  "\033[;32m MySQL already installed by Sources \033[0m"
#         read -p "Enter old 'MySQL Sources dir',  (eg: ~/downloads/mysql-5.6.21/:  )    " Mysql_old_dir
         echo -e "\033[;32m Removing MySQL ... \033[0m"
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  mysql/
fi
}


function Install_Mysql_56 {

clear 
echo -e "============= \033[;34m Begin Install ${VERSION[mysql56]} \033[0m ================="

# Create run_user: mysql  
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

# Create dir and chown 
for i in $Mysql_data $Mysql_libdir $Mysql_logdir ; do 
mkdir -p $i && chown -R mysql:mysql $i 
done 

# Download Mysql source packages 
cd $Download_dir 

if [ -f "${VERSION[mysql56]}.tar.gz" ]; then
   tar -zxf ${VERSION[mysql56]}.tar.gz
else
   wget ${URL[mysql56]}
fi

# make/make install Mysql 
tar -zxf ${VERSION[mysql56]}.tar.gz 
cd ${VERSION[mysql56]} 
cmake -DCMAKE_INSTALL_PREFIX=$Mysql_base -DMYSQL_DATADIR=$Mysql_data -DSYSCONFDIR=/etc -DMYSQL_USER=$Mysql_user -DWITH_MYISAM_STORAGE_ENGING=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=$Mysql_libdir -DMYSQL_TCP_PORT=$Mysql_port -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
make && make install 

# Create MySQL config
cat  > /etc/my.cnf << END 					
[mysqld]
basedir = /usr/local/mysql
datadir = /data0/mysql
port = 3336
# server_id = .....
socket = /var/lib/mysql/mysql.sock
default-storage-engine = MyISAM
user = mysql
log-error = /var/log/mysql/error.log
pid-file = /var/lib/mysql/mysqld.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[client]
port = 3336
socket = /var/lib/mysql/mysql.sock
END

# Copy/change MySQL init_file 
cp -a support-files/mysql.server.sh /etc/init.d/mysqld 
sed -i 's#^basedir.*#basedir=/usr/local/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir.*#datadir=/data0/mysql#' /etc/init.d/mysqld
chmod a+x /etc/init.d/mysqld

# Install MySQL data_tables 
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data0/mysql --user=mysql    
/etc/init.d/mysqld start 

# Add $Mysql_base to root's variable
sed  -i.bak "/^# User/a Mysql_home='/usr/local/mysql'" ~/.bash_profile
sed -i 's#^PATH=.*#&:$Mysql_home/bin#' ~/.bash_profile
source  ~/.bash_profile

# Set Mysql's root password is: '123456' 
mysql -S $Mysql_libdir/mysql.sock -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123456');"

echo -e "============= \033[;32m  ${VERSION[mysql56]} has been installed \033[0m ================="


}



function Remove_Mysql {

clear 
echo -e "============= \033[;34m  Begin Remove ${VERSION[mysql56]}  \033[0m ================="
if [ -d $Mysql_base ]; then 
	cd /usr/local/ && rm -fr mysql
else 
	echo -e "\033[;31m  MySQL not install, exit \033[0m "
	exit 2
fi

}









