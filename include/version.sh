 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		version.sh
 #* Description:    The script used to display software version
 #* Last modified:	2015-08-21 15:43
 #* *****************************************************************************/
#!/bin/bash
 
echo -e "============= \033[;34m List All software Version: \033[0m ================="
# Define 'All_Version' for display all software version 
All_Version="pcre-8.37 zlib-1.2.8 bzip2-1.0.6 openssl-1.0.2d mysql-5.6.26 mariadb-10.0.21 postgresql-9.4.4 apr-1.5.2 apr-1.5.2 nginx-1.8 httpd-2.4.16 lighttd-1.4.36 spawn-fcgi-1.6.4 libiconv-1.14 libmcrypt-2.5.8 Mcrypt-2.6.8 mhash-0.9.9.9 php-5.6.12 PHP_fpm_5.6 memcache-2.2.7 xcache-3.2.0 PDO_MYSQL-1.0.2"


Pcre_ver='pcre-8.37'
Zlib_ver='zlib-1.2.8'
Bzip2_ver='bzip2-1.0.6'
Openssl_ver='openssl-1.0.2d'

Mysql_56_ver='mysql-5.6.26'
Mariadb_10_ver='mariadb-10.0.21'
Postgresql_94_ver='postgresql-9.4.4'

# Apache Dependent Packages
Apr_ver='apr-1.5.2'
Apr_util_ver='apr-util-1.5.4'

Nginx_18_ver='nginx-1.8.0'
Apache_24_ver='httpd-2.4.16'
Lighttpd_14_ver='lighttd-1.4.36'
Spawn_fcgi_ver='spawn-fcgi-1.6.4'



# PHP Dependent Packages
Libiconv_ver='libiconv-1.14'
Libmcrypt_ver='libmcrypt-2.5.8'
Mcrypt_ver='mcrypt-2.6.8'
Mhash_ver='mhash-0.9.9.9'


PHP_56_ver='php-5.6.12'
PHP_fpm_56_ver=${PHP_56_ver/php/php-fpm}


# PHP Extensions
Memcache_ver='memcache-2.2.7'
Xcache_ver='xcache-3.2.0'
Pdo_mysql_ver='PDO_MYSQL-1.0.2'


