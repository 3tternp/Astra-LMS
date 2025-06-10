# Exit on error
$ErrorActionPreference = "Stop"

Write-Host "🔧 Setting up Astra-LMS on Windows..."

# Backend setup
Write-Host "➡️ Setting up backend environment..."

# Create and activate virtual environment
python -m venv venv

Write-Host "Activating virtual environment..."
& .\venv\Scripts\Activate.ps1

Write-Host "Installing backend Python dependencies..."
pip install --upgrade pip
pip install -r .\backend\requirements.txt

Write-Host "Making and applying migrations..."
Set-Location -Path .\backend
python manage.py makemigrations
python manage.py migrate

Write-Host "Creating Django superuser..."
python manage.py createsuperuser

Set-Location -Path ..

# Frontend setup
Write-Host "➡️ Setting up frontend environment..."

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "npm not found, please install Node.js and npm before continuing."
    exit 1
}

Set-Location -Path .\frontend
npm install

Write-Host "✅ Setup complete!"

Write-Host "Starting backend server..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd ..\backend; .\venv\Scripts\Activate.ps1; python manage.py runserver"

Write-Host "Starting frontend server..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd .\frontend; npm start"
