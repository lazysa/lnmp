
#!/bin/bash


function Display_Select {
############################# which MySQL Version do you want to install? #############################
echo -e "============= \033[;34m Start Select DB \033[0m ================="
echo -e  "You have 5 options for your DataBase install."
echo -e "+++++++++++++  \033[;34m 1: Install MySQL-5.6.26 (Default) \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 2: Install MySQL-5.1.73 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 3: Install MySQL-5.1.73 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 4: Install MariaDB-10.0.21 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 5: Install MariaDB-10.0.21 \033[0m +++++++++++++ "

read -p "Enter your choice (1, 2, 3, 4 or 5): , otherwise select "1" DBSelect


case $DBSelect in 
    1)
	    echo "You will install MySQL-5.6.26"
	;;
	2)
		echo "You will install MySQL-5.6.26"
	;;
	3)
		echo "You will install MySQL-5.6.26"
	;;
	4)
		echo "You will install MySQL-5.6.26"
	;;
	5)
		echo "You will install MySQL-5.6.26"
	;;
	*)
		echo "No input,You will install MySQL-5.6.26"
		DBSelect="1"
	;;	
esac

	
############################# which Apache Version do you want to install? #############################
echo -e "============= \033[;34m Start Select Web_Server \033[0m ================="
echo -e  "You have 2 options for your Web_Server install."
echo -e "+++++++++++++ \033[;34m 1: Install Apache-2.4 <Default> \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 2: Install Apache-2.2 \033[0m +++++++++++++ "

read -p "Enter your choice (1, 2): , otherwise select 1" WebSelect

case $WebSelect in 
    1)
	    echo "You will install Apache-2.4"
	;;
	2)
		echo "You will install Apache-2.2"
	;;
	*)
		echo "No input,You will install Apache-2.4"
		WebSelect="1"
	;;
esac


############################# which Nginx Version do you want to install? #############################
echo -e "============= \033[;34m Start Select Web_Server \033[0m ================="
echo -e  "You have 2 options for your Web_Server install."
echo -e "+++++++++++++ \033[;34m 1: Install Nginx-1.8 <Default> \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 2: Install Nginx-1.6 \033[0m +++++++++++++ "

read -p "Enter your choice (1, 2): , otherwise select 1" NginxSelect


case $NginxSelect in 
    1)
	    echo "You will Nginx-1.8"
	;;
	2)
		echo "You will install Nginx-1.6"
	;;
	*)
		echo "No input,You will install Nginx-1.8"
		NginxSelect="1"
	;;
esac



############################# which PHP Version do you want to install?  #############################

echo -e "============= \033[;34m Start Select PHP \033[0m ================="
echo -e  "You have 2 options for your PHP install."
echo -e "+++++++++++++ \033[;34m 1: Install PHP-5.6.12 <Default> \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 2: Install php-5.5 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 3: Install php-5.4 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 4: Install php-5.3 \033[0m +++++++++++++ "
echo -e "+++++++++++++  \033[;34m 5: Install php-5.2.17 \033[0m +++++++++++++ "


read -p "Enter your choice (1, 2, 3, 4 or 5): , otherwise select 1" PHPSelect

case $PHPSelect in 
    1)
	    echo "You will install PHP-5.6.12"
	;;
	2)
		echo "You will install PHP-5.5"
	;;
	3)
		echo "You will install PHP-5.4"
	;;
	4)
		echo "You will install PHP-5.3"
	;;
	5)
		echo "You will install PHP-5.2.17"
	;;
	*)
		echo "No input, You will install PHP-5.6.12"
		PHPSelect="1"
	;;
esac

	
}