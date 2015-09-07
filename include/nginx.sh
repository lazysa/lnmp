 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		nginx.sh
 #* Description:   
 #* Last modified:	2015-08-25 11:47
 #* *****************************************************************************/
#!/bin/bash
 


function Chenck_Nginx {
# Check Nginx is install, remove Pre-Built version

clear 
echo -e "============= \033[;34m Begin Nginx_install Check \033[0m ================="

rpm -qa |grep -oP "^nginx-\d.*"
if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Nginx via yum is detected, Removing Nginx ... \033[0m"
        yum remove httpd -y

elif [ -d "$Nginx_base" ]; then
         echo -e  "\033[;32m Nginx already installed by Sources \033[0m"
#         read -p "Enter old 'Nginx Sources dir',  (eg: Nginx-1.8/  )    " Nginx_old_dir
         echo -e "\033[;32m Removing Nginx ... \033[0m"
         cd $Nginx_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  Nginx/
fi
}


function Install_Nginx_18 {

clear 
echo -e "============= \033[;34m Begin Install $Nginx_18_ver \033[0m ================="

yum install pcre-devel -y 

# Download Nginx 
cd $Download_dir 
wget $Nginx_18_url

# ======== Install Nginx ========
# Create run_user: nginx  
groupadd nginx
useradd -g nginx -s /sbin/nologin nginx 


# Create dir and set owner
for i in /usr/local/nginx /var/log/nginx /var/lib/nginx ; do
	 mkdir -p $i && chown -R nginx:nginx $i 
done 

tar -zxf $Nginx_18_ver.tar.gz
cd $Nginx_18_ver
./configure --prefix=$Nginx_base --with-ipv6 --user=nginx --group=nginx --pid-path=/var/lib/nginx/nginx.pid --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-pcre=/opt/downloads/pcre-8.37 --with-zlib=/opt/downloads/zlib-1.2.8 --with-openssl=/opt/downloads/openssl-1.0.2d --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module
make && make install

ln -s /usr/local/nginx /etc/nginx


# Add $Nginx_base to root's user_variable
sed -i.bak "/^# User/a Nginx_home='/usr/local/nginx'" ~/.bash_profile
sed -i 's#^PATH=.*#&:$Nginx_home/sbin#' ~/.bash_profile
source  ~/.bash_profile

cp -a conf/nginx.conf  /etc/nginx/conf/

### Config Nginx  
# Modify Nginx processor 
Processor=`grep "processor" /proc/cpuinfo |wc -l` 
sed -i.bak "/worker_processes/s/1/$Processor/" $Nginx_base/conf/nginx.conf


# Create test index_file 
cat > /etc/nginx/html/index.html << END
<?php
phpinfo();
?>
END

# Start Nginx service 
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
		
echo -e "============= \033[;32m  $Nginx_18_ver has been installed \033[0m ================="

}


function Remove_Nginx {

clear 
echo -e "============= \033[;34m  Begin Remove $Nginx_18_ver  \033[0m ================="
if [ -d $Nginx_base ]; then 
	cd /usr/local/ && rm -fr nginx
else 
	echo -e "\033[;31m  Nginx not install, exit \033[0m "
	exit 2
fi

}
