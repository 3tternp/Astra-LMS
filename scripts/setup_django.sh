#!/bin/bash

# Define a helper function to show messages
function info {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

# Run makemigrations for the users app
info "Running makemigrations for 'users' app..."
docker-compose exec backend python manage.py makemigrations users

# Apply migrations
info "Applying all migrations..."
docker-compose exec backend python manage.py migrate

# Create a superuser
info "Creating superuser (you will be prompted)..."
docker-compose exec backend python manage.py createsuperuser
