#!/bin/bash
# Author: Justin Clayton
# This script is for automating the creation of a new static webpage or simple
# flask application.

# Check required args, project name and project type, are given
if [ $# -ne 2 ]; then
  echo "Need a directory name for project and a project type" 1>&2
  exit 1
fi

# Check project type is supported (ie template files exist)
if [[ $2 != "web" ]] && [[ $2 != "flask" ]]; then
  echo "Project type not yet supported" 1>&2
  exit 1
fi

# Make project directory and change to it
mkdir "$1"
cd "$1"

# Copy skeleton files for project type
cp -r $SKELETONS/$2/* .

# Use github api to create remote repo
curl --user "jtclayt" --data '{"name": '\"$1\"', "private": false}' https://api.github.com/user/repos

# Git stuff to push local repo up with an initial commit
git init
git remote add origin git@github.com:jtclayt/"$1".git
git add .
git commit -m "Initial commit"
git push -u origin master
code .
