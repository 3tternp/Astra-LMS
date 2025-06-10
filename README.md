# Astra-LMS
```
Astra-LMS/
├── backend/
│   ├── manage.py
│   ├── lms/ (Django project)
│   ├── users/ (User management app)
│   ├── courses/ (LMS app)
│   └── ...
├── frontend/
│   ├── package.json
│   ├── src/
│   └── ...
├── .env
├── docker-compose.yml
├── README.md

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
