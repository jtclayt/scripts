#!/bin/bash
# Author: Justin Clayton
# This script automates setting up a MERN full stack application
# It requires a project name

if [ $# -lt 2 ]; then
  echo "Need a project name and DB name" 1>&2
  exit 1
fi

echo "Starting MERN project $1..."
mkdir "$1"
cd "$1"

echo "Setting up server folders and files..."
cp -r $SKELETONS/mern/. .
sed -i "s/DB_NAME/$2/g" server/config/mongoose.config.js

echo "Initializing NPM, installing Express and Mongoose..."
npm init -y
sudo npm install express mongoose cors

echo "Starting React app..."
sudo npx create-react-app client
sudo chown -R jc:jc client
cd client
sudo rm README.md
sudo npm install axios @reach/router
sudo rm -rf .git .gitignore
cd ..

echo "Initialize git repo and make initial commit"
git init
git add .
git commit -m "Initial commit"

code .
