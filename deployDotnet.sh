#!/bin/bash
# Author: Justin Clayton
# This script automates building an ASP.NET project with a mysql database.

# Setup database
cd ..
dotnet restore
dotnet ef migrations add DeployMigration
dotnet ef database update

# Setup supervisor
sudo apt install supervisor -y
dotnet publish
sudo cat deploy/supervisor.txt > "/etc/supervisor/conf.d/$1.conf"
sudo service supervisor restart
