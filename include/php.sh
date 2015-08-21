 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		php.sh
 #* Description:   
 #* Last modified:	2015-08-21 16:34
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
         read -p "Enter old 'PHP Sources dir', (eg: /opt/downloads/php5.3.3/:    )" PHP_old_dir
         echo "Removing PHP..."
         cd $Mysql_old_dir && make uninstall ; make clean && cd /usr/local/ && rm -fr  php/
fi
}
