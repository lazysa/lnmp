 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		apache.sh
 #* Description:    Auto-Install script for the Apache HTTP Server 
 #* Last modified:	2015-08-21 23:51
 #* *****************************************************************************/
#!/bin/bash
 
 


function Chenck_Apache {
	# Check Apache is install, remove Pre-Built version

	clear 
	echo -e "============= \033[;34m Begin Apache_install Check \033[0m ================="

	rpm -qa |grep -oP "^httpd-\d.*"
	if [ $? -eq 0 ]; then
		clear 
		echo -e "\033[;32m You has been installed Apache via yum is detected, Removing Apache ... \033[0m"
		yum remove httpd -y

	elif [ -d "$Apache_base" ]; then
		 echo -e  "\033[;32m Apache already installed by Sources \033[0m"
	#         read -p "Enter old 'Apache Sources dir',  (eg: ${VERSION[httpd24]}/  )    " Apache_old_dir
		 echo -e "\033[;32m Removing Apache ... \033[0m"
		 cd $Apache_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  Apache/
	fi
}


function Install_Apache_24 {

	clear 
	echo -e "============= \033[;34m Begin Install ${VERSION[httpd24]} \033[0m ================="

	yum install pcre-devel -y 

	# Download Apr/Apr_util and PHP
	cd $Download_dir || mkdir -p $Download_dir
	wget -c ${URL[apr]} ${URL[apr-util]}

	if [ -f "${VERSION[httpd24]}.tar.gz" ]; then
		tar -zxf ${VERSION[httpd24]}.tar.gz
	else
		wget ${URL[httpd24]}
	fi

	# Install Apr/Apr_util
	tar -zxf ${VERSION[httpd24]}.tar.gz 
	tar -zxf ${VERSION[apr]}.tar.gz 
	tar -zxf ${VERSION[apr-util]}.tar.gz 

	cp -fr ${VERSION[apr]} ${VERSION[httpd24]}/srclib/apr 
	cp -fr ${VERSION[apr-util]} ${VERSION[httpd24]}/srclib/apr-util 



	# ======== Install Apache ========
	# Create run_user: Apache  
	groupadd www
	useradd -G www -s /sbin/nologin apache

	# Create dir and set owner
	for i in $Apache_libdir $Apache_logdir ; do 
		mkdir -p $i && chown -R apache:www $i 
	done 

	cd ${VERSION[httpd24]}
	./configure --prefix=$Apache_base --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support --with-mpm=worker
	make && make install

	# Copy/change Apache init_file 
	cp build/rpm/httpd.init /etc/init.d/httpd  
	chmod a+x /etc/init.d/httpd 
	chkconfig --add httpd 
	sed -i.bak "/^httpd/i HTTPD=\'/usr/local/apache/bin/httpd\'" /etc/init.d/httpd
	sed -i "/^pidfile/i PIDFILE=\'/var/lib/httpd/httpd.pid'" /etc/init.d/httpd

	# Change Apache run_user: apache
	sed -i.bak '/daemon$/s/daemon/apache/' /etc/httpd/conf/httpd.conf

	# Add support for php type, included index 
	sed -i '/[^#]AddType.*tgz$/a    AddType application/x-httpd-php .php .phtml' /etc/httpd/conf/httpd.conf
	sed -i '/[^#]AddType.*phtml$/a   AddType application/x-httpd-php-source .phps' /etc/httpd/conf/httpd.conf
	sed -i 's/\([^#] DirectoryIndex.*\)/\1 index.php/' /etc/httpd/conf/httpd.conf

	# Create test index_file 
	cat > $Apache_base/htdocs/index.php << END 
	<?php
	phpinfo();
	?>
	END


	# Add $Apache_base to root's user_variable
	sed  -i.bak "/^# User/a Apache_home='/usr/local/apache'" ~/.bash_profile
	sed -i 's#^PATH=.*#&:$Apache_home/bin#' ~/.bash_profile
	ln -s /usr/local/apache /etc/httpd
	source  ~/.bash_profile

	# Start Apache service 
	/etc/init.d/httpd start 

	echo -e "============= \033[;32m  ${VERSION[httpd24]} has been installed \033[0m ================="

}


function Remove_Apache {

	clear 
	echo -e "============= \033[;34m  Begin Remove ${VERSION[httpd24]}  \033[0m ================="
	if [ -d $Apache_base ]; then 
		cd /usr/local/ && rm -fr apache
	else 
		echo -e "\033[;31m  ${VERSION[httpd24]} not install, exit \033[0m "
		exit 2
	fi

}




