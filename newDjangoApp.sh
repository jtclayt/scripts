#!/bin/bash
# Author: Justin Clayton
# This script is for automatically creating a new app in an existing Django
# project directory, it then commits and pushes the change to GitHub.

if [ $# -ne 1 ]; then
  echo "Need an app name" 1>&2
  exit 1
fi

# Make new app
source /mnt/c/Users/jtcla/Documents/projects/dojo/python/my_environments/djangoPy3Env/bin/activate
python manage.py startapp "$1"
cd "$1"

# Copy skeleton files for app and add urls.py
cp -r /mnt/c/Users/jtcla/Documents/projects/skeletons/django/app/* .
cat /mnt/c/Users/jtcla/Documents/projects/skeletons/django/files/app_urls.py > urls.py

commit.sh "Created app $1 in project"

echo "Don't forget to update settings.py and project urls.py!"
