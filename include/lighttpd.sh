#!/bin/bash
# Description:   Auto-Install script for the Web Server ——  Lighttpd 

 
function Chenck_Lighttpd {
# Check Lighttpd is install, remove Pre-Built version

clear 
echo -e "============= \033[;34m Begin Lighttpd_install Check \033[0m ================="

rpm -qa |grep -oP "^nginx-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Lighttpd via yum is detected, Removing Lighttpd ... \033[0m"
        yum remove httpd -y

elif [ -d "$Lighttpd_base" ]; then
         echo -e  "\033[;32m Lighttpd already installed by Sources \033[0m"
#         read -p "Enter old 'Lighttpd Sources dir',  (eg: Lighttpd-1.8/  )    " Lighttpd_old_dir
         echo -e "\033[;32m Removing Lighttpd ... \033[0m"
         cd $Lighttpd_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  Lighttpd/
fi
}


function Install_Lighttpd_14 {

clear 
echo -e "============= \033[;34m Begin Install $Lighttpd_14_ver \033[0m ================="


# Download Lighttpd 
cd $Download_dir 
wget $Lighttpd_14_url

# ======== Install Lighttpd ========
# Create run_user: lighttpd  
groupadd lighttpd
useradd -M -s /sbin/nologin -g lighttpd lighttpd


# Create dir and set owner
for i in /usr/local/lighttpd /var/log/lighttpd /var/lib/lighttpd ; do
	 mkdir -p $i && chown -R lighttpd:lighttpd $i 
done 

tar -zxf $Lighttpd_14_ver.tar.gz
cd $Lighttpd_14_ver
./configure --prefix=/usr/local/lighttpd --enable-lfs --with-openssl=~/downloads/openssl-1.0.2d --with-pcre --with-zlib --with-bzip2 --with-memcache
make && make install

# Copy init.d script file 
cp -a doc/initscripts/rc.lighttpd.redhat /etc/init.d/lighttpd
sed -i.bak 's#\(^lighttpd\)=.*#\1="/usr/local/lighttpd/sbin/lighttpd"#' /etc/init.d/lighttpd

chmod a+x /etc/init.d/lighttpd

# Add fastcgi support
sed -i.bak '/^## FastCGI/a include "conf.d/fastcgi.conf"' /etc/lighttpd/modules.conf

cat >> /etc/lighttpd/cjnf.d/fastcgi.conf << END
fastcgi.server = (
  ".php" => ((
    "host" => "127.0.0.1",
    "port" => "9000",
#   "docroot" => "/srv/www/servers/www.example.org/htdocs/"
  )))
END


# Create test index_file 
cat > /etc/nginx/html/index.html << END
<?php
phpinfo();
?>
END

# Start Lighttpd service 
/etc/init.d/lighttpd start
		
echo -e "============= \033[;32m  $Lighttpd_14_ver has been installed \033[0m ================="

}


function Remove_Lighttpd {

clear 
echo -e "============= \033[;34m  Begin Remove $Lighttpd_14_ver  \033[0m ================="
if [ -d $Lighttpd_base ]; then 
	cd /usr/local/ && rm -fr lighttpd
else 
	echo -e "\033[;31m  Lighttpd not install, exit \033[0m "
	exit 2
fi

}
