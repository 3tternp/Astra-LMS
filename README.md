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
How to Run Everything
```
Install Docker and Docker Compose.
Create a .env file in the root lms directory by copying .env.example and filling in a strong SECRET_KEY.
```
From the root lms directory, run the build command:
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
After creating the superuser, log into the Django admin (http://localhost:8000/admin), go to the User model, and set the user's role to ADMIN.
Your application is now running!
```
```
Frontend: http://localhost
Backend API: http://localhost:8000
Django Admin: http://localhost:8000/admin
```
