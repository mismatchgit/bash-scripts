#!/bin/bash 
clear
echo "============================================"
echo "          WordPress Install Script          "
echo "============================================"
echo
echo "=============Database details==============="
echo -n "Database Name(Use _(Underscore) instead of -(hypen)) : "
read dbname
echo -n "Database User : "
read dbuser
echo -n "Database Password : "
read -s dbpass
echo "=============Creating Database==============="
echo
sudo mysql -u $dbuser -p$dbpass <<MYSQL_SCRIPT
CREATE DATABASE $dbname;
MYSQL_SCRIPT
if [ $? -ne 0 ]; then
    echo "Error: Database creation failed."
    exit 1
fi
echo
echo "=============Wordpress Login Admin details=================="
echo -n "Project Name : "
read sitename
echo -n "Email Address : "
read wpemail
echo -n "Admin User Name : "
read wpuser
echo -n "Admin User Password : "
read wppass
echo "============================================"
echo "Whole WordPress installation Process."
echo "============================================"
echo "Downloading wordpress latest version..."
curl -O https://wordpress.org/latest.tar.gz > /dev/null
echo "Extracting tarball wordpress..."
tar -zxvf latest.tar.gz > /dev/null
#creating directory name after project
mkdir $sitename
#copy file to dir named after project
cp -rf wordpress/* ./$sitename
#Setting the required permission
sudo chown -R www-data:www-data /var/www/html/$sitename > /dev/null
sudo chmod -R 777 /var/www/html/$sitename > /dev/null
#remove files from wordpress folder
rm -R wordpress
#create wp config
echo
echo "Creating database configuration file..."
cd $sitename
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
sed -i "s/'database_name_here'/'$dbname'/g" wp-config.php
sed -i "s/'username_here'/'$dbuser'/g" wp-config.php
sed -i "s/'password_here'/'$dbpass'/g" wp-config.php

#install wp_cli to complete the installation
echo "Installing WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
echo "Installing wordpress..."
wp core install --url="localhost/$sitename" --title="$sitename" --admin_user="$wpuser" --admin_password="$wppass" --admin_email="$wpemail"
#remove zip file
cd ..
rm latest.tar.gz
#remove bash script
#rm wp-install.sh
echo "========================="
echo "Installation is complete."
echo "========================="
echo "Visit your site: http://localhost/$sitename"
