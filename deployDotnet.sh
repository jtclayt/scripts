#!/bin/bash
# Author: Justin Clayton
# This script automates deploying an ASP.NET project with a mysql database.

cd ..
# Set Nginx
sudo apt update
sudo apt install nginx -y
sudo rm /etc/nginx/sites-available/default
sudo cat deploy/nginx.txt > /etc/nginx/sites-available/default

# Setup mysql
sudo apt update
sudo apt install mysql-server -y
sudo mysql -Bse "show databases;"

# Setup dotnet
cd ~
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-sdk-3.1
dotnet tool install dotnet-ef --global
sudo reboot
echo 'Dont forget to add appsettings.json file!'
