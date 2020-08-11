#!/bin/bash
# Author: Justin Clayton
# This script automates setting up a new ASP.NET project, adding in the needed
# files and altering a few files for the project to be ready to run.
# It then sets up a new GitHub repo and commits the project to the master branch.

if [ $# -lt 1 ]; then
  echo "Need a project" 1>&2
  exit 1
fi

# Make project directory and change to project
echo "Starting ASP.NET project $1..."
dotnet new web --no-https -o "$1"
cd "$1"

# Add entity framework packages
dotnet add package Pomelo.EntityFrameworkCore.MySql --version 3.1.1
dotnet add package Microsoft.EntityFrameworkCore.Design --version 3.1.5

# Copy in base files
cp -r $SKELETONS/dotnet/default/* .
cat $SKELETONS/dotnet/files/Startup.cs > Startup.cs
cat $SKELETONS/dotnet/files/csproj.txt > $1.csproj
sed -i "s/ProjectName/$1/g" Startup.cs
sed -i "s/ProjectName/$1/g" Controllers/HomeController.cs
sed -i "s/ProjectName/$1/g" Models/User.cs
sed -i "s/ProjectName/$1/g" Models/Context.cs

echo "@using $1" > Views/_ViewImports.cshtml
echo "@using $1.Models" >> Views/_ViewImports.cshtml
echo '@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers' >> Views/_ViewImports.cshtml

# Add entity framework and configure database connection settings
cp $SKELETONS/dotnet/files/appsettings.json .
cp $SKELETONS/dotnet/files/appsettings.Development.json .
sed -i "s/ProjectName/$1/" appsettings.json
sed -i "s/ProjectName/$1/" appsettings.Development.json

if [ $# -eq 3 ] && [[ $3 == 'git' ]]; then
  echo "Creating GitHub repo..."
  # Copy in git ignore file
  cp $SKELETONS/dotnet/files/.gitignore .
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
