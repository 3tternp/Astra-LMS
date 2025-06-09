# Astra-LMS
```
/Astra-LMS/
|-- .env.example              # Example environment variables
|-- docker-compose.yml        # <<< Main Docker orchestration file
|
|-- /backend/
|   |-- Dockerfile            # Instructions to containerize Django
|   |-- requirements.txt      # Python dependencies
|   |-- manage.py
|   |
|   |-- /lms_backend/
|   |   |-- __init__.py
|   |   |-- asgi.py
|   |   |-- settings.py       # <<< CODE PROVIDED
|   |   |-- urls.py           # <<< CODE PROVIDED
|   |   +-- wsgi.py
|   |
|   |-- /users/
|   |   |-- __init__.py
|   |   |-- admin.py
|   |   |-- apps.py
|   |   |-- models.py         # <<< CODE PROVIDED
|   |   |-- permissions.py    # <<< CODE PROVIDED
|   |   |-- serializers.py    # (Placeholder)
|   |   +-- views.py          # (Placeholder)
|   |
|   +-- /courses/
|       |-- __init__.py
|       |-- admin.py
|       |-- apps.py
|       |-- models.py         # (Placeholder for Course, Module, etc.)
|       |-- serializers.py    # (Placeholder)
|       +-- views.py          # <<< CODE PROVIDED
|
+-- /frontend/
    |-- Dockerfile            # Instructions to containerize React + Nginx
    |-- nginx.conf            # Nginx configuration
    |-- package.json
    |-- /public/
    |-- /src/
    |   |-- /api/
    |   |   +-- axiosConfig.js  # <<< CODE PROVIDED
    |   |-- /hooks/
    |   |   +-- useAuth.js      # <<< CODE PROVIDED
    |   |-- /pages/
    |   |   |-- AdminDashboardPage.js
    |   |   |-- DashboardPage.js
    |   |   |-- LoginPage.js
    |   |   +-- UnauthorizedPage.js
    |   |-- /routes/
    |   |   +-- ProtectedRoute.js # <<< CODE PROVIDED
    |   +-- App.js              # <<< CODE PROVIDED
    +-- ...
```
**How to Run Everything**
```
Install Docker and Docker Compose.
Create a .env file in the root lms directory by copying .env.example
and filling in a strong SECRET_KEY.
```
**From the root lms directory, run the build command:**
```
docker-compose build
Once the build is complete, start the services:
```
```
docker-compose up
Run initial database migrations: In a new terminal, run:
```
docker-compose exec backend python manage.py migrate
Create a superuser (Admin):
```
docker-compose exec backend python manage.py createsuperuser
After creating the superuser,
log into the Django admin (http://localhost:8000/admin),
go to the User model, and set the user's role to ADMIN.
```
**Your application is now running!**
```
Frontend: http://localhost
Backend API: http://localhost:8000
Django Admin: http://localhost:8000/admin
```
Setup Guide for Windows IIS server 
#pre-requisites 
Part 1: Prerequisites & Manual Setup
Before running the script, you must manually install and configure the following on your Windows Server.

Install IIS (Internet Information Services):

Go to Server Manager > Manage > Add Roles and Features.
Select Web Server (IIS).
Under Role Services, ensure the following are checked:
Common HTTP Features (all sub-items)
Application Development > CGI
Management Tools > IIS Management Console
Install URL Rewrite Module:

Download and install the IIS URL Rewrite Module. This is crucial for both the React frontend and the API proxy.
Install Python:

Download and install Python for Windows (e.g., Python 3.9+) from the official website.
Crucially, check the box that says "Add Python to PATH" during installation.
Open PowerShell or Command Prompt and verify the installation: python --version and pip --version.
Install Node.js and npm:

Download and install the LTS version of Node.js from the official website. This will also install npm.
Verify the installation: node --version and npm --version.
Install Git:

Download and install Git for Windows from the official website.
Install a Database:

This guide assumes you have a PostgreSQL server already installed and accessible from your IIS machine. Note the database name, user, password, host, and port.
Part 2: The Deployment Automation Script
This batch script automates the creation of IIS sites, application pools, and the configuration for both the frontend and backend.

Instructions:

Create a new file named deploy_lms.bat.
Copy and paste the entire script below into this file.
Carefully edit the "CONFIGURATION" section at the top of the script.
Open Command Prompt or PowerShell as an Administrator, navigate to where you saved the script, and run it.
