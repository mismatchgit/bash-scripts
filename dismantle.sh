#!/bin/bash
sudo systemctl stop httpd
sudo rm -f /var/www/html/*
sudo yum remove httpd wget unzip -y

