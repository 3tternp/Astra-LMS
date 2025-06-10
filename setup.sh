#!/bin/bash

# Exit on error
set -e

echo "🔧 Setting up Astra-LMS on Linux/macOS..."

# Backend setup
echo "➡️ Setting up backend environment..."

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

echo "Installing backend Python dependencies..."
pip install --upgrade pip
pip install -r backend/requirements.txt

echo "Making and applying migrations..."
cd backend
python manage.py makemigrations
python manage.py migrate

echo "Creating Django superuser..."
python manage.py createsuperuser

cd ..

# Frontend setup
echo "➡️ Setting up frontend environment..."

if ! command -v npm &> /dev/null
then
    echo "npm not found, please install Node.js and npm before continuing."
    exit 1
fi

cd frontend
npm install

echo "✅ Setup complete!"

echo "Starting backend server..."
cd ../backend
source ../venv/bin/activate
python manage.py runserver &

echo "Starting frontend server..."
cd ../frontend
npm start
