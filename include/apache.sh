 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		apache.sh
 #* Description:   
 #* Last modified:	2015-08-21 15:44
 #* *****************************************************************************/
#!/bin/bash
 
 
Apache_base='/usr/local/apache'
Apache_libdir='/var/lib/Apache/Apache.sock'
Apache_port='3306'
Apache_user='www'

 

function Check_Apache  {
rpm -qa httpd |grep -oP "^httpd-\d.*"
if [ $? -eq 0 ]; then
        echo "Removing Apache..."
        yum remove httpd -y

elif [ -d /usr/local/apache/ ]; then
         echo "Apache already installed by Sources"
         read -p "Enter old 'Apache Sources dir', (eg: /opt/downloads/httpd-2.4.16/:   )    " Apache_old_dir
         echo "Removing Apache..."
         cd $Apache_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr apache/
fi
}


function Check_Apache {
# Check Apache is install, remove Pre-Built version

clear 
echo -e "============= \033[;34m Begin Apache_install Check \033[0m ================="

rpm -qa httpd |grep -oP "^httpd-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Apache via yum is detected, Removing Apache ... \033[0m"
        yum remove httpd -y

elif [ -d /usr/local/Apache/ ]; then
         echo -e  "\033[;32m Apache already installed by Sources \033[0m"
         read -p "Enter old 'Apache Sources dir',  (eg: httpd-2.4.16/  )    " Apache_old_dir
         echo -e "\033[;32m Removing Apache ... \033[0m"
         cd $Apache_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  Apache/
fi
}



function Install_Apache_5.6 {


clear 
echo -e "============= \033[;34m Begin Install Apache-5.6.26 \033[0m ================="

cd $download_dir 
yum install pcre-devel -y 
wget $Apr_url $Apr_util_url $Httpd_url


# Create run_user: Apache  
groupadd www
useradd -G www -s /sbin/nologin apache

tar -jxf httpd-2.4.16.tar.bz2 
tar -jxf apr-1.5.2.tar.bz2 
tar -jxf apr-util-1.5.4.tar.bz2 

cp -fr apr-1.5.2 httpd-2.4.16/srclib/apr 
cp -fr apr-util-1.5.4 httpd-2.4.16/srclib/apr-util 

cd httpd-2.4.16 
./configure --prefix=/usr/local/apache --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support --with-mpm=worker
make && make install

# Copy/change Apache init_file 
cp build/rpm/httpd.init /etc/init.d/httpd  
chmod a+x /etc/init.d/httpd 
chkconfig --add httpd 
ln -s /usr/local/apache /etc/httpd  
ln -s /usr/local/apache/bin/httpd /usr/sbin/httpd 
ln -s /usr/local/apache/bin/apachectl /usr/sbin/apachectl 


sed -i.bak "/^httpd/i httpd=\'/usr/local/apache/bin/httpd\'" /etc/init.d/httpd
sed -i "/^pidfile/i pidfile=\'/var/lib/httpd/httpd.pid'" /etc/init.d/httpd


vim /etc/init.d/httpd 
pidfile=${PIDFILE-/etc/httpd/logs/${prog}.pid}


sed -i.bak '/daemon$/s/daemon/apache/' /etc/httpd/conf/httpd.conf
sed -i '/[^#]AddType.*tgz$/a    AddType application/x-httpd-php .php .phtml' /etc/httpd/conf/httpd.conf
sed -i '/[^#]AddType.*phtml$/a   AddType application/x-httpd-php-source .phps' /etc/httpd/conf/httpd.conf
sed -i 's/\([^#] DirectoryIndex.*\)/\1 index.php/' /etc/httpd/conf/httpd.conf

# Create test index_file 
cat > /usr/local/apache/htdocs/index.php << END 
<?php
phpinfo();
?>
END



# Create dir and chown 
for i in /var/lib/httpd /var/log/httpd ; do 
mkdir -p $i && chown -R apache:www $i 
done 

# make/make install 
cmake --DCMAKE_INSTALL_PREFIX=$Mysql_base -DMYSQL_DATADIR=$Mysql_data -DSYSCONFDIR=/etc -DMYSQL_USER=$Mysql_user -DWITH_MYISAM_STORAGE_ENGING=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=$Mysql_libdir -DMYSQL_TCP_PORT=$Mysql_port -DENABLED_LOCAL_INFILE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
make && install 

# Create MySQL config
# Copy/change MySQL init_file 
cp -a support-files/mysql.server.sh /etc/init.d/mysqld 
sed -i 's#^basedir.*#basedir=/usr/local/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir.*#datadir=/data0/mysql#' /etc/init.d/mysqld
chmod a+x /etc/init.d/mysqld

# Install MySQL data_tables 
/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data0/mysql --user=mysql    
/etc/init.d/mysqld start 

# Set root's variable
sed -i 's#^PATH=.*#&:/usr/local/mysql/bin#' ~/.bash_profile
source  ~/.bash_profile


}






















function Remove_Apache {

clear 
echo -e "============= \033[;34m  Begin Remove httpd-2.4.16  \033[0m ================="
if [ -d $Mysql_base ]; then 
	cd $Mysql_base && rm -fr $Mysql_base
else 
	echo -e "\033[;31m  httpd not install, exit \033[0m "
	exit 2
fi

}




