#!/bin/bash
# Author: Justin Clayton
# This script automates the deploy process for a MERN project on AWS

if [ $# -ne 1 ]; then
  echo "Need a repo name" 1>&2
  exit 1
fi
export repoName="$1"

# Build React client
cd ~/$repoName/client
npm run build
cd ~

# prep server
sudo apt update
sudo apt install nodejs npm nginx git -y
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs
sudo apt install build-essential

# Front end set up
cd ~/$repoName/client
sudo rm -rf /var/www/html
sudo mv build /var/www/html
sudo service nginx restart

# Fixing routes
sudo grep -rl localhost /var/www/html | xargs sed -i 's/http:\/\/localhost:8000//g'

# Setup backend
cd ~/$repoName/server
npm i

# MongoDB setup
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt update
sudo apt install -y mongodb-org
sudo service mongod start
service mongod status

# configure nginx
sudo chmod 700 /etc/nginx/sites-available/default
cat ~/$repoName/deploy/nginx-config.txt > /etc/nginx/sites-available/default
cd ~/$repoName/server
sudo service nginx restart

# setup daemon to run server
sudo npm i pm2 -g
pm2 start server.js
pm2 status
