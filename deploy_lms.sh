#!/bin/bash

# This script is a general guideline for hosting a web application
# (like Django or Flask) on Ubuntu or Debian. You will need to
# customize it based on your specific application's requirements.

# Ensure the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo"
   exit 1
fi

# --- Update System Packages ---
echo "Updating system packages..."
apt update
apt upgrade -y

# --- Install Necessary Dependencies ---
echo "Installing Python and pip..."
apt install python3 python3-pip -y

# You might need other dependencies based on your application
# For example, if you are using PostgreSQL:
# apt install postgresql postgresql-contrib libpq-dev -y

# If you are using MySQL:
# apt install mysql-server python3-mysql -y

# --- Install web server (Choose either Nginx or Apache) ---
# --- Option 1: Install Nginx ---
echo "Installing Nginx..."
apt install nginx -y
systemctl start nginx
systemctl enable nginx

# --- Option 2: Install Apache ---
# echo "Installing Apache..."
# apt install apache2 libapache2-mod-wsgi-py3 -y
# systemctl start apache2
# systemctl enable apache2

# --- Create Application Directory ---
APP_NAME="your_app_name" # Replace with your application name
APP_PATH="/var/www/$APP_NAME"
echo "Creating application directory: $APP_PATH"
mkdir -p "$APP_PATH"
chown "$USER":"$USER" "$APP_PATH" # Change ownership to your user (replace "$USER" if needed)
chmod 755 "$APP_PATH"

# --- Transfer Application Files ---
echo "Please transfer your application files to: $APP_PATH"
echo "This script assumes your application files are now in $APP_PATH"

# --- Create and Activate Virtual Environment ---
echo "Creating and activating virtual environment..."
python3 -m venv "$APP_PATH/venv"
source "$APP_PATH/venv/bin/activate"

# --- Install Application Dependencies ---
# Assuming you have a requirements.txt file in your application directory
if [ -f "$APP_PATH/requirements.txt" ]; then
    echo "Installing application dependencies from requirements.txt..."
    pip install -r "$APP_PATH/requirements.txt"
else
    echo "Warning: No requirements.txt file found. Install dependencies manually."
    # Add any specific pip install commands for your application here
    # For example:
    # pip install django
    # pip install flask
fi

# --- Configure Web Server ---
# This part depends heavily on whether you chose Nginx or Apache
# and the specifics of your application (e.g., WSGI configuration).

# --- Example for Django with Nginx and Gunicorn ---
# Install Gunicorn: pip install gunicorn
# Create a systemd service file for Gunicorn (e.g., /etc/systemd/system/your_app.service):
#
# [Unit]
# Description=Gunicorn instance for your_app
# After=network.target
#
# [Service]
# User=your_user # Replace with your username
# Group=www-data
# WorkingDirectory=/var/www/your_app
# ExecStart=/var/www/your_app/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 your_app.wsgi:application
# Restart=on-failure
#
# [Install]
# WantedBy=multi-user.target
#
# Enable and start the service:
# systemctl enable your_app.service
# systemctl start your_app.service
#
# Configure Nginx to act as a reverse proxy for Gunicorn.
# Create or edit your Nginx site configuration (e.g., /etc/nginx/sites-available/your_app):
#
# server {
#     listen 80;
#     server_name your_domain.com; # Replace with your domain
#
#     location / {
#         proxy_pass http://127.0.0.1:8000;
#         proxy_set_header Host $host;
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#     }
# }
#
# Create a symbolic link to enable the site:
# ln -s /etc/nginx/sites-available/your_app /etc/nginx/sites-enabled/
# Test Nginx configuration and reload:
# nginx -t
# systemctl reload nginx

# --- Example for Flask with Nginx and Gunicorn ---
# The Gunicorn and Nginx configuration would be similar to Django.
# In the Gunicorn command, you would point to your Flask application instance:
# ExecStart=/var/www/your_app/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 your_app:app
# (Assuming your Flask app is in a file named your_app.py and the instance is named 'app')

# --- Example for Apache with Django (using mod_wsgi) ---
# Ensure mod_wsgi is installed: apt install libapache2-mod-wsgi-py3
# Configure your Apache virtual host (e.g., in /etc/apache2/sites-available/your_app.conf):
#
# <VirtualHost *:80>
#     ServerName your_domain.com # Replace with your domain
#     ServerAlias www.your_domain.com
#
#     Alias /static /var/www/your_app/static # If you have static files
#     <Directory /var/www/your_app/static>
#         Require all granted
#     </Directory>
#
#     <Directory /var/www/your_app>
#         <Files wsgi.py>
#             Require all granted
#         </Files>
#     </Directory>
#
#     WSGIDaemonProcess your_app python-path=/var/www/your_app:/var/www/your_app/venv/lib/python3.X/site-packages # Adjust python version if needed
#     WSGIProcessGroup your_app
#     WSGIScriptAlias / /var/www/your_app/wsgi.py
#
#     ErrorLog ${APACHE_LOG_DIR}/error.log
#     CustomLog ${APACHE_LOG_DIR}/access.log combined
# </VirtualHost>
#
# Enable the site and reload Apache:
# a2ensite your_app.conf
# systemctl reload apache2

# --- Run the Application (for development/testing purposes directly) ---
# For Django:
# cd "$APP_PATH"
# python manage.py runserver 0.0.0.0:8000

# For Flask:
# export FLASK_APP=your_app.py # Replace with your main Flask file
# flask run --host=0.0.0.0 --port=8000

echo "Application setup complete! You might need to further configure your web server"
echo "and ensure your application is running correctly."
echo "Consider using a process manager like systemd or Supervisor for production deployment."
