 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		apache.sh
 #* Description: Install script for the Apache HTTP Server 
 #* Last modified:	2015-08-21 23:51
 #* *****************************************************************************/
#!/bin/bash
 
 
Apache_base='/usr/local/apache'
Apache_libdir='/var/lib/httpd/httpd.sock'


function Chenck_Apache {
# Check Apache is install, remove Pre-Built version

clear 
echo -e "============= \033[;34m Begin Apache_install Check \033[0m ================="

rpm -qa httpd |grep -oP "^httpd-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Apache via yum is detected, Removing Apache ... \033[0m"
        yum remove httpd -y

elif [ -d "$Apache_base" ]; then
         echo -e  "\033[;32m Apache already installed by Sources \033[0m"
         read -p "Enter old 'Apache Sources dir',  (eg: httpd-2.4.16/  )    " Apache_old_dir
         echo -e "\033[;32m Removing Apache ... \033[0m"
         cd $Apache_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  Apache/
fi
}


function Install_Apache-2.4 {

clear 
echo -e "============= \033[;34m Begin Install Httpd-2.4.16 \033[0m ================="

yum install pcre-devel -y 

# Download/install Apr and Apr_util
cd $Download_dir 
wget $Apr_url $Apr_util_url $Httpd_url

tar -jxf httpd-2.4.16./bin/tar.bz2 
tar -jxf apr-1.5.2./bin/tar.bz2 
tar -jxf apr-util-1.5.4./bin/tar.bz2 

cp -fr apr-1.5.2 httpd-2.4.16/srclib/apr 
cp -fr apr-util-1.5.4 httpd-2.4.16/srclib/apr-util 


# ======== Install Apache ========
# Create run_user: Apache  
groupadd www
useradd -G www -s /sbin/nologin apache

# Create dir and set owner
for i in /var/lib/httpd /var/log/httpd ; do 
mkdir -p $i && chown -R apache:www $i 
done 

cd httpd-2.4.16 
./configure --prefix=$Apache_base --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support --with-mpm=worker
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

# Change apache run_user: apache
sed -i.bak '/daemon$/s/daemon/apache/' /etc/httpd/conf/httpd.conf

# Add support for php type, included index 
sed -i '/[^#]AddType.*tgz$/a    AddType application/x-httpd-php .php .phtml' /etc/httpd/conf/httpd.conf
sed -i '/[^#]AddType.*phtml$/a   AddType application/x-httpd-php-source .phps' /etc/httpd/conf/httpd.conf
sed -i 's/\([^#] DirectoryIndex.*\)/\1 index.php/' /etc/httpd/conf/httpd.conf

# Create test index_file 
cat > /usr/local/apache/htdocs/index.php << END 
<?php
phpinfo();
?>
END


# Add $Apache_base to root's user_variable
sed -i 's#^PATH=.*#&:/usr/local/httpd/sbin#' ~/.bash_profile
source  ~/.bash_profile
/etc/init.d/httpd start 

echo -e "============= \033[;32m  httpd-2.4.16 has been installed \033[0m ================="

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




