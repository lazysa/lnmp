 #/*******************************************************************************
 #* Author:  Josery.
 #* Blog:    www.chenxu.info
 #* Filename:		VERSION.sh
 #* Description:    The script used to display software VERSION
 #* Last modified:	2015-08-21 15:43
 #* *****************************************************************************/
#!/bin/bash


# Load "url.sh"
. ./include/url.sh 
	
# Declare array index of {URL}	
# declare -a SOFT
SOFT=(echo "${!URL[@]}")

#echo "${SOFT[@]}"
# Declare array {VERSION}
declare -A VERSION

# Get VERSION numbers of {URL}
for i in `echo "${SOFT[@]}"` ; do
        arg=$i
        VERSION[$arg]=$(echo ${URL[$arg]} |sed -r  "s@http(s)?://.*{1,10}/(.*).(tar.*|tgz)@\2@g" |tr 'A-Z' 'a-z')
	shift  
done 
#
echo  ${VERSION[zlib]} ${VERSION[pcre]} ${VERSION[php56]} ${VERSION[pdo_mysql]}
 
