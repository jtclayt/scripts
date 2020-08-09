# Scripts

1. newProject.sh
Sets up static webpages and Flask applications using a set of suctom template files.

2. newDjango.sh
Sets up a new full stack django application with a user registration/login already predbuilt
using Djangos authentication system. Loads custom template files and modifies project files
so app is ready to start out of the box.

3. newDotnet.sh
Sets up a new ASP.NET full stack application with Models, Views, and Controllers (MVC).
Project has a custom _Layout.cshtml file for injecting the html different pages into.

4. commit.sh
Simple script for adding and commiting changes to a remote GitHub repo, allows submitting a
message and selecting a branch to push to.

5. deployDjango.sh
Script for automating the deployment of a Django application to an AWS EC2 Ubuntu server.
Sets up required installs and configures Gunicorn and NGINX to communicate with app.
Repo must already be pulled down to server and an IP to deploy on must be provided.
Names must be replaced with specific project names. The file also expects that there are templates
for gunicorn and nginx configuration.
