 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		init.sh
 #* Description:  init install environment  
 #* Last modified:	2015-08-12 16:21
 #* *****************************************************************************/
#!/bin/bash
 

if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
    echo "Already add aliyum repos, nothing"
else

    # Add Aliyun_mirrors
    OS_version=`cat /etc/redhat-release |awk '{print $3}' |awk -F. '{print $1'}`
    Url_5='http://mirrors.aliyun.com/repo/Centos-5.repo'
    Url_6='http://mirrors.aliyun.com/repo/Centos-6.repo'
    Url_7='http://mirrors.aliyun.com/repo/Centos-7.repo'

    cd /etc/yum.repos.d
	
    # Backup default repos 
    mv CentOS-Base.repo CentOS-Base.repo.bak

    if [ "$OS_version" == "5" ]; then 
         wget -O CentOS-Base.repo $Url_5
    elif [ "$OS_version" == "6" ]; then
         wget -O CentOS-Base.repo $Url_6
    elif [ "$OS_version" == "7" ]; then
         wget -O CentOS-Base.repo $Url_7
    fi

    # Clean yum_cache
    yum clean all
    # Make yum_cache
    yum makecache 

fi




