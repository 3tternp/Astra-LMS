#!/bin/bash

echo "▶️ Running makemigrations for 'users' app..."
docker-compose exec backend python manage.py makemigrations users

echo "▶️ Applying migrations..."
docker-compose exec backend python manage.py migrate

echo "▶️ Creating superuser..."
docker-compose exec backend python manage.py createsuperuser
