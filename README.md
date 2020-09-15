# Scripts

1. newProject.sh<br>
Sets up static webpages and Flask applications using a set of custom template files.

2. newDjango.sh<br>
Sets up a new full stack django application with a user registration/login already pre-built
using Djangos authentication system. Loads custom template files and modifies project files
so app is ready to start out of the box.

3. newDotnet.sh<br>
Sets up a new ASP.NET full stack application with Models, Views, and Controllers (MVC).
Project has a custom _Layout.cshtml file for injecting the different html pages into.

4. newMern.sh<br>
Sets up a new full stack web application with MongoDB, Express and Node backend and a React frontend.
Build server and client file structure and sets up basic connections between files to streamline
starting a new MERN project.

5. commit.sh<br>
Simple script for adding and commiting changes to a remote GitHub repo, allows submitting a
message and selecting a branch to push to.

6. deployDjango.sh<br>
Script for automating the deployment of a Django application to an AWS EC2 Ubuntu server.
Sets up required installs and configures Gunicorn and NGINX to communicate with app.
Repo must already be cloned to server and an IP to deploy on must be provided as an argument.
Names must be replaced with specific project names. The file also expects that there are templates
for gunicorn and nginx configuration.

7. buildDotnet.sh<br>
Script autmates the setup up steps for intstalling and preparing Nginx, MySQL, and .NET on
an Ubuntu 18.04/20.04 instance to prepare for a full stack application deployment.

8. deployDotnet.sh<br>
Script picks up after the installation of dependencies in buildDotnet.sh. Runs the actual setup
of MySQL database and .NET supervisor for handling server requests in the background with a
daemon.

