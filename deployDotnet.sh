#!/bin/bash
# Author: Justin Clayton
# This script automates building an ASP.NET project with a mysql database.

if [ $# -lt 1 ]; then
  echo "Need a project name" 1>&2
  exit 1
fi

# Setup database
cd ..
dotnet restore
dotnet ef migrations add DeployMigration
dotnet ef database update

# Setup supervisor
sudo apt install supervisor -y
dotnet publish
sudo touch "/etc/supervisor/conf.d/$1.conf"
sudo chmod 766 "/etc/supervisor/conf.d/$1.conf"
sudo cat deploy/supervisor.txt > "/etc/supervisor/conf.d/$1.conf"
sudo service supervisor restart
