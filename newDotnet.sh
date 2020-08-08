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

# Copy in base files
cp -r $SKELETONS/dotnet/default/* .
cat $SKELETONS/dotnet/files/Startup.cs > Startup.cs
sed -i "s/namespace/namespace $1/" Startup.cs
sed -i "s/namespace/namespace $1.Controllers/" Controllers/HomeController.cs
sed -i "s/namespace/namespace $1.Models/" Models/User.cs

echo "@using $1" > Views/_ViewImports.cshtml
echo "@using $1.Models" >> Views/_ViewImports.cshtml
echo '@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers' >> Views/_ViewImports.cshtml

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
