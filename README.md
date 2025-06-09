# Astra-LMS
```
/lms/
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
