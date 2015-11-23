 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		url.sh
 #* Description:   The script used to save all software's download url
 #* Last modified:	2015-08-21 15:44
 #* *****************************************************************************/
#!/bin/bash
 

# Declare array {URL
declare -A URL

URL[pcre]='http://exim.mirror.fr/pcre/pcre-8.37.tar.gz'
URL[zlib]='http://zlib.net/zlib-1.2.8.tar.gz'
URL[bzip2]='http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz'
URL[openssl]='http://www.openssl.org/source/openssl-1.0.2d.tar.gz'

URL[mysql56]='http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.26.tar.gz'
URL[mariadb]='http://mirrors.opencas.cn/mariadb/mariadb-10.0.21/source/mariadb-10.0.21.tar.gz'
URL[postgresql]='https://ftp.postgresql.org/pub/source/v9.4.4/postgresql-9.4.4.tar.gz'

URL[apr]='http://apache.fayea.com//apr/apr-1.5.2.tar.gz'
URL[apr-util]='http://apache.fayea.com//apr/apr-util-1.5.4.tar.gz'

URL[httpd24]='http://apache.fayea.com/httpd/httpd-2.4.16.tar.gz'
URL[nginx18]='http://nginx.org/download/nginx-1.8.0.tar.gz'
URL[lighttpd]='http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.36.tar.gz'
URL[spawn-fcgi]='http://download.lighttpd.net/spawn-fcgi/releases-1.6.x/spawn-fcgi-1.6.4.tar.gz'

URL[libiconv]='http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz'
URL[libmcrypt]='http://sourceforge.net/projects/mcrypt/files/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz'
URL[mcrypt]='http://ourceforge.net/projects/mcrypt/files/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz'
URL[mhash]='http://sourceforge.net/projects/mhash/files/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz'

URL[php56]='http://cn2.php.net/get/php-5.6.12.tar.gz/from/this/mirror'

URL[memcache]='http://pecl.php.net/get/memcache-2.2.7.tgz'
URL[xcache]='http://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz'
URL[pdo_mysql]='http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz'


