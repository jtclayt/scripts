#!/bin/bash
# Author: Justin Clayton
# This script automates setting up a new ASP.NET project, adding in the needed
# files and altering a few files for the project to be ready to run.
# It then sets up a new GitHub repo and commits the project to the master branch.

if [ $# -lt 1 ]; then
  echo "Need a project" 1>&2
  exit 1
fi

# Make project directory and change to it
echo "Starting ASP.NET project $1..."
dotnet new web --no-https -o "$1"
cd "$1"

# Add gitignore, copy in root level folders and files
cp /mnt/c/Users/jtcla/Documents/projects/skeletons/dotnet/*

if [ $# -eq 3 ] && [[ $3 == 'git' ]]; then
  echo "Creating GitHub repo..."
  # Use github api to create remote repo
  res=$(curl --user "jtclayt" --data '{"name": '\"$2\"', "private": false}' https://api.github.com/user/repos)
  if [[ $res =~ "Bad credentials" ]]; then
    echo "Something went wrong with creating repo aborting..." 1>&2
    cd ..
    rm -rf "$1"
    exit 1
  fi

  # Git stuff to push local repo up with an initial commit
  git init
  git remote add origin git@github.com:jtclayt/"$2".git
  git add .
  git commit -m "Initial commit, created ASP.NET project"
  git push -u origin master
fi

# Open in VS Code
code .
