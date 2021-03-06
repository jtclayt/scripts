#!/bin/bash
# Author: Justin Clayton
# This script automates setting up a new Django project, adding in the needed
# files and altering a few files for the project to be ready to run.
# Templates and static files must exist locally as well as a template urls.py
# for the project and app level as well as a template views.py for the app.
# It then sets up a new GitHub repo and commits the project to the master branch.

if [ $# -lt 1 ]; then
  echo "Need a project name" 1>&2
  exit 1
fi

# Make project directory and change to it
source $DJANGO_ENV/bin/activate
echo "Starting project $1..."
django-admin startproject "$1"
cd "$1"

# Add python interpreter setting and git ignore
cp -r $SKELETONS/django/.vscode .
echo .vscode > .gitignore

# Create main app, add templates, static files, and update urls.py and views.py
echo "Starting app..."
python manage.py startapp app
cd app
echo "Coppying templates, static, urls.py, and views.py into app..."
cp -r $SKELETONS/django/app/* .
cat $SKELETONS/django/files/app_urls.py > urls.py
cat $SKELETONS/django/files/views.py > views.py
cd ..

# Create users app, add templates, static files, and update urls.py and views.py
echo "Starting users..."
python manage.py startapp users
cd users
echo "Coppying templates, static, urls.py, and views.py into app..."
cp -r $SKELETONS/django/users/static .
cp -r $SKELETONS/django/users/templates .
cp $SKELETONS/django/users/forms.py .
cat $SKELETONS/django/users/urls.py > urls.py
cat $SKELETONS/django/users/views.py > views.py
cat $SKELETONS/django/users/models.py > models.py
cd ..

# Make changes to settings.py and urls.py in project folder
cd "$1"
echo "Updating settings.py and urls.py in project..."
sed -i "s/INSTALLED_APPS = \[/INSTALLED_APPS = \[\n    'app',\n    'users',/" settings.py
cat $SKELETONS/django/files/settings.py >> settings.py
cat $SKELETONS/django/files/urls.py > urls.py
cd ..

if [[ $2 == 'git' ]]; then
  echo "Creating GitHub repo..."
  # Use github api to create remote repo
  res=$(curl --user "jtclayt" --data '{"name": '\"$1\"', "private": false}' https://api.github.com/user/repos)
  if [[ $res =~ "Bad credentials" ]]; then
    echo "Something went wrong with creating repo aborting..." 1>&2
    cd ..
    rm -rf "$1"
    exit 1
  fi
  # Add .gitignore
  cp $SKELETONS/django/files/.gitignore .
  # Git stuff to push local repo up with an initial commit
  git init
  git remote add origin git@github.com:jtclayt/"$1".git
  git add .
  git commit -m "Initial commit, created new Django project and app"
  git push -u origin master
fi

# Open in VS Code
code .
