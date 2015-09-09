#!/bin/bash
# Description:   Auto-Install script for the Mariadb Server
  
function Check_Mariadb {
# Check Mariadb is or not install, remove installed version
# Remove Pre-Built ( yum ) version or others source version 

clear 
echo -e "============= \033[;34m Begin Mariadb_install Check \033[0m ================="

rpm -qa |grep -oP "^mariadb-server-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Mariadb via yum is detected, Removing Mariadb ... \033[0m"
        yum remove mariadb -y

elif [ -d "Mariadb" ] || [ -d "/opt/mariadb" ]; then
         echo -e  "\033[;32m Mariadb already installed by Sources \033[0m"
#         read -p "Enter old 'Mariadb Sources dir',  (eg: ~/downloads/mariadb-10.0.21/:  )    " Mariadb_old_dir
         echo -e "\033[;32m Removing Mariadb ... \033[0m"
         cd $Mariadb_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  mariadb/
fi
}


function Install_Mariadb_56 {

clear 
echo -e "============= \033[;34m Begin Install $Mariadb_10_ver \033[0m ================="

# Create run_user: mariadb  
groupadd mariadb
useradd -g mariadb -s /sbin/nologin mariadb

# Create dir and chown 
for i in $Mariabd_data $Mariadb_libdir $Mariadb_logdir ; do 
mkdir -p $i && chown -R mariadb:mariadb $i 
done 

# Download Mariadb source packages 
cd $Download_dir 

if [ -f "$Mariadb_10_ver.tar.gz" ]; then
   tar -zxf $Mariadb_10_ver.tar.gz
else
   wget $Mariadb_10_url
fi

# make/make install Mariadb
tar -zxf $Mariadb_10_ver.tar.gz 
cd $Mariadb_10_ver 
cmake -DCMAKE_INSTALL_PREFIX=Mariadb -DMYSQL_DATADIR=$Mariadb_data -DSYSCONFDIR=/etc -DMYSQL_USER=$Mariadb_user -DWITH_MYISAM_STORAGE_ENGING=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=$Mariadb_libdir -DMYSQL_TCP_PORT=$Mariadb_port -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
make && make install 

# Create Mariadb config
cat  > /etc/ma.cnf << END 					
[mysql]
basedir = /usr/local/mariadb
datadir = /data0/mariadb
port = 3356
# server_id = .....
socket = /var/lib/mariadb/mariadb.sock
default-storage-engine = MyISAM
user = mariadb
log-error = /var/log/mariadb/error.log
pid-file = /var/lib/mariadb/mariadbd.pid
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
END

# Copy/change Mariadb init_file 
cp -a support-files/mariadb.server.sh /etc/init.d/mariadbd 
sed -i 's#^basedir.*#basedir=/usr/local/mariadb#' /etc/init.d/mariadbd
sed -i 's#^datadir.*#datadir=/data0/mariadb#' /etc/init.d/mariadbd
chmod a+x /etc/init.d/mariadbd

# Install Mariadb data_tables 
/usr/local/mariadb/scripts/mariadb_install_db --basedir=/usr/local/mariadb --datadir=/data0/mariadb --user=mariadb    
/etc/init.d/mariadbd start 

# Add Mariadb to root's variable
sed  -i.bak "/^# User/a Mariadb_home='/usr/local/mariadb'" ~/.bash_profile
sed -i 's#^PATH=.*#&:$Mariadb_home/bin#' ~/.bash_profile
source  ~/.bash_profile

# Set Mariadb's root password is: '123456' 
mysql -S $Mariadb_libdir/mariadb.sock -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123456');"

echo -e "============= \033[;32m  $Mariadb_10_ver has been installed \033[0m ================="


}


function Remove_Mariadb {

clear 
echo -e "============= \033[;34m  Begin Remove $Mariadb_10_ver  \033[0m ================="
if [ -d $Mariadb_base ]; then 
	cd /usr/local/ && rm -fr mariadb
else 
	echo -e "\033[;31m  Mariadb not install, exit \033[0m "
	exit 2
fi

}









