 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		php.sh
 #* Description:    Auto-Install script for PHP  
 #* Last modified:	2015-08-24 16:01
 #* *****************************************************************************/
#!/bin/bash
 



function Check_PHP {
# Check PHP is install, remove Pre-Built version
rpm -qa php |grep php
if [ $? -eq 0 ]; then
        echo "Removing PHP..."
        yum remove php -y

elif [ -d /usr/local/php/ ]; then
         echo "Php already installed by Sources"
#         read -p "Enter old 'PHP Sources dir', (eg: /opt/downloads/php5.6.10/:    )" PHP_old_dir
         echo "Removing PHP..."
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  php/
fi
}

 
function Chenck_PHP {
# Check PHP isn’t install, remove Pre-Built version

clear 
echo -e "============= \033[;34m Begin PHP_install Check \033[0m ================="

rpm -qa |grep -oP "^php-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed PHP via yum is detected, Removing PHP ... \033[0m"
        yum remove php -y

elif [ -d "$PHP_base" ]; then
         echo -e  "\033[;32m PHP already installed by Sources \033[0m"
         read -p "Enter old 'PHP Sources dir',  (eg: ~/downloads/PHP-5.6.10/  )    " PHP_old_dir
         echo -e "\033[;32m Removing PHP ... \033[0m"
         cd $PHP_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  php/
fi
}

function Install_PHP_56 {

clear 
echo -e "============= \033[;34m Begin Install $PHP_56_ver  \033[0m ================="


yum install libpng libjpeg -y 

# Download some PHP Dependent Packages and PHP
cd $Download_dir 
wget $Bzip2_url $Libiconv_url $Libmcrypt_url $Mcrypt_url $Mhash_url $PHP_56_url 

# Download some PHP Extensions
wget $Memcache_url $Xcache_url $Pdo_mysql_url 


	
echo "+++++++++ Begin Install $Bzip2_ver +++++++++++"
tar -zxf $Bzip2_ver.tar.gz
cd $Bzip2_ver
# To assist in cross-compiling
sed -i.bak '/^CC/s/gcc/& -fPIC/' Makefile
make 
make install 
cd ../

echo "+++++++++ Begin Install $Libiconv_ver +++++++++++"
tar -zxf $Libiconv_ver.tar.gz 
cd $Libiconv_ver 
./configure 
make && make install 
cd ../ 

echo "+++++++++ Begin Install $Libmcrypt_ver +++++++++++"
tar -zxf $Libmcrypt_ver.tar.gz 
cd $Libmcrypt_ver 
./configure 
make 
make install 
/sbin/ldconfig 
cd libltdl/ 
./configure --enable-ltdl-install 
make 
make install 
cd ../../ 

echo "+++++++++ Begin Install $Mcrypt_ver +++++++++++"
tar -zxf $Mcrypt_ver.tar.gz 
cd $Mcrypt_ver 
/sbin/ldconfig 
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH 
./configure 
make 
make install 
cd ../ 


echo "+++++++++ Begin Install $Mash_ver +++++++++++"
tar -zxf $Mhash_ver.tar.gz  
cd $Mhash_ver
./configure 
make 
make install 
cd ../ 


echo "++++++++++++++++ Begin Install $PHP_56_ver +++++++++++++++++++"
tar -zxf $PHP_56_ver.tar.gz
cd $PHP_56_ver
./configure --prefix=/usr/local/php --with-apxs2=$Apache_base/bin/apxs --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --enable-fpm --with-openssl --with-zlib --with-bz2 --with-gettext --with-mhash --with-mcrypt --with-iconv=/usr/local/libiconv --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-mysql=/usr/local/mysql --with-pdo-mysql=/usr/local/mysql --enable-gd-native-ttf --enable-bcmath --enable-mbstring --enable-zip --enable-soap --enable-sockets --enable-ftp --without-pear 
make && make install 
cp php.ini-production /etc/php.ini  
cd ../

# Install PHP Extensions
echo "++++++++++++++++ Begin Install PHP Extensions ++++++++++++++++"
echo "+++++++++ Begin Install $Memcache_ver +++++++++++"
tar -zxf $Memcache_ver.tgz 
cd $Memcache_ver
/usr/local/php/bin/phpize
./configure --with-php-config=$PHP_base/bin/php-config 
make && make install 
cd ../

echo "+++++++++ Begin Install $Xcache_ver +++++++++++"
wget $Xcache_url
tar -zxf $Xcache_ver.tar.gz 
cd $Xcache_ver
/usr/local/php/bin/phpize 
./configure --with-php-config=$PHP_base/bin/php-config 
make && make install 

# Config Xcache admin_pages 
cp -ar /usr/src/xcache-3.2.0/htdocs $Apache_base/htdocs/xcache
cat xcache.ini >> /etc/php.ini << END 
[xcache.admin]
xcache.admin.enable_auth = On
# Login user 
xcache.admin.user = "xcache"   
# echo "123456" |md5sum 
xcache.admin.pass = "f447b20a7fcbf53a5d5be013ea0b15af"  

# Xcache cache file 
[xcache]
xcache.mmap_path =  "/tmp/xcache"   
END

# Create Xcache cache file 
touch /tmp/xcache 
chmod 777 /tmp/xcache 
cd ../

echo "+++++++++ Begin Install $Pdo_mysql_ver +++++++++++"
wget $Pdo_mysql_url
tar -zxf $Pdo_mysql_ver.tgz 
cd $Pdo_mysql_ver
/usr/local/php/bin/phpize 
ln -s $Mysql_base/include/* /usr/local/include 
./configure --with-php-config=$PHP_base/bin/php-config --with-pdo-mysql=$Mysql_base  
make && make install 


# Config PHP Extensions
cat >> /etc/php.ini << END 
extension_dir = "/usr/local/php/lib/php/extensions/no-debug-zts-20131226/"          
extension = "memcache.so"
extension = "pdo_mysql.so" 
END


echo "++++++++++++++++ Begin Install $PHP_fpm_ver  ++++++++++++++++"
useradd -G www -s /sbin/nologin php-fpm  
cp -a /usr/local/php/etc/php-fpm.conf.default $PHP_base/etc/php-fpm.conf 
cp /usr/src/php-5.6.12/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm

# Change php-fpm run_user 
sed -i '/^user/s/nobody/php-fpm/' $PHP_base/etc/php-fpm.conf 
sed -i '/^group/s/nobody/php-fpm/' $PHP_base/etc/php-fpm.conf

chmod a+x /etc/init.d/php-fpm
/etc/init.d/php-fpm start 


echo -e "============= \033[;32m  PHP-5.6.12 has been installed \033[0m ================="

}


function Remove_PHP {

clear 
echo -e "============= \033[;34m  Begin Remove PHP-5.6.12  \033[0m ================="
if [ -d $PHP_base ]; then 
	cd /usr/local/ && rm -fr PHP
else 
	echo -e "\033[;31m  PHP not install, exit \033[0m "
	exit 2
fi

}






