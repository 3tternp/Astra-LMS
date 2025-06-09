@echo off
setlocal

:: ============================================================================
:: LMS DEPLOYMENT SCRIPT FOR WINDOWS IIS
:: ============================================================================
:: PURPOSE:
:: This script automates the deployment of the Django/React LMS application.
:: It sets up the backend as a FastCGI application and the frontend as a
:: static site with a reverse proxy to the backend API.
::
:: USAGE:
:: 1. Ensure all prerequisites are installed (IIS, Python, Node.js, Git).
:: 2. Edit the CONFIGURATION variables below.
:: 3. Run this script as an Administrator.
:: ============================================================================

:: ----------------------------------------------------------------------------
:: (1) CONFIGURATION - EDIT THESE VARIABLES
:: ----------------------------------------------------------------------------
set "PROJECT_PARENT_DIR=C:\inetpub\wwwroot\lms"
set "GIT_REPO_URL=https://github.com/your-username/your-lms-repo.git"

:: Backend Site Configuration
set "BACKEND_SITE_NAME=lms-backend"
set "BACKEND_PORT=8001"
set "PYTHON_EXE_PATH=C:\Python39\python.exe" :: <-- IMPORTANT: Verify this path

:: Frontend Site Configuration
set "FRONTEND_SITE_NAME=lms-frontend"
set "FRONTEND_PORT=80"

:: Database & Django Environment Variables
set "DB_NAME=lms_db"
set "DB_USER=lms_user"
set "DB_PASS=strongpassword123"
set "DB_HOST=localhost"
set "DB_PORT=5432"
set "SECRET_KEY=your-super-secret-key-that-is-long-and-random-for-production"
set "DJANGO_DEBUG=False"

:: ============================================================================
:: (2) SCRIPT EXECUTION - DO NOT EDIT BELOW THIS LINE
:: ============================================================================

echo.
echo [INFO] Starting LMS Deployment...
echo [INFO] Project will be deployed to: %PROJECT_PARENT_DIR%
echo.

:: --- Create Project Directories ---
if not exist "%PROJECT_PARENT_DIR%" (
    echo [STEP] Creating project directory...
    mkdir "%PROJECT_PARENT_DIR%"
) else (
    echo [INFO] Project directory already exists.
)
cd /d "%PROJECT_PARENT_DIR%"

:: --- Clone Source Code ---
if not exist "%PROJECT_PARENT_DIR%\backend" (
    echo [STEP] Cloning source code from Git...
    git clone %GIT_REPO_URL% .
) else (
    echo [INFO] Source code already exists. Skipping clone.
)

:: Set paths
set "BACKEND_DIR=%PROJECT_PARENT_DIR%\backend"
set "FRONTEND_DIR=%PROJECT_PARENT_DIR%\frontend"
set "VENV_DIR=%BACKEND_DIR%\venv"

:: ----------------------------------------------------------------------------
:: (3) BACKEND SETUP (DJANGO)
:: ----------------------------------------------------------------------------
echo.
echo [INFO] ### Setting up Backend (Django) ###

:: --- Create Python Virtual Environment & Install Dependencies ---
if not exist "%VENV_DIR%" (
    echo [STEP] Creating Python virtual environment...
    %PYTHON_EXE_PATH% -m venv "%VENV_DIR%"
)
echo [STEP] Installing Python dependencies...
call "%VENV_DIR%\Scripts\activate.bat"
pip install --upgrade pip
pip install -r "%BACKEND_DIR%\requirements.txt"
pip install wfastcgi

:: --- Run wfastcgi-enable ---
echo [STEP] Enabling wfastcgi...
wfastcgi-enable
set "WFASTCGI_PATH=%VENV_DIR%\Lib\site-packages\wfastcgi.py"

:: --- Create Backend IIS App Pool and Site ---
echo [STEP] Configuring IIS for Backend...
%windir%\system32\inetsrv\appcmd.exe add apppool /name:%BACKEND_SITE_NAME% /managedRuntimeVersion:"" /managedPipelineMode:Integrated
%windir%\system32\inetsrv\appcmd.exe add site /name:%BACKEND_SITE_NAME% /bindings:http/*:%BACKEND_PORT%: /physicalPath:"%BACKEND_DIR%"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" /section:system.webServer/handlers /+[name='Python FastCGI',path='*',verb='*',modules='FastCgiModule',scriptProcessor='%VENV_DIR%\Scripts\python.exe|%WFASTCGI_PATH%',resourceType='Unspecified',requireAccess='Script']

:: --- Set Environment Variables for Backend in IIS ---
echo [STEP] Setting environment variables for Django...
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe',arguments='|%WFASTCGI_PATH%'].environmentVariables.[name='DJANGO_SETTINGS_MODULE',value='lms_backend.settings']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='PYTHONPATH',value='%BACKEND_DIR%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='SECRET_KEY',value='%SECRET_KEY%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='DEBUG',value='%DJANGO_DEBUG%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='POSTGRES_DB',value='%DB_NAME%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='POSTGRES_USER',value='%DB_USER%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='POSTGRES_PASSWORD',value='%DB_PASS%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='POSTGRES_HOST',value='%DB_HOST%']"
%windir%\system32\inetsrv\appcmd.exe set config "%BACKEND_SITE_NAME%" -section:system.webServer/fastCgi /+"[fullPath='%VENV_DIR%\Scripts\python.exe'].environmentVariables.[name='POSTGRES_PORT',value='%DB_PORT%']"

:: --- Create web.config for Django ---
echo [STEP] Creating web.config for Django...
(
    echo ^<?xml version="1.0" encoding="UTF-8"?^>
    echo ^<configuration^>
    echo   ^<system.webServer^>
    echo     ^<handlers^>
    echo       ^<remove name="Python FastCGI" /^>
    echo       ^<add name="Python FastCGI" path="*" verb="*" modules="FastCgiModule" scriptProcessor="%VENV_DIR%\Scripts\python.exe|%WFASTCGI_PATH%" resourceType="Unspecified" requireAccess="Script" /^>
    echo     ^</handlers^>
    echo   ^</system.webServer^>
    echo ^</configuration^>
) > "%BACKEND_DIR%\web.config"

:: --- Database Migrations & Static Files ---
echo [STEP] Running Django database migrations...
call "%VENV_DIR%\Scripts\python.exe" "%BACKEND_DIR%\manage.py" migrate

echo [STEP] Collecting Django static files...
call "%VENV_DIR%\Scripts\python.exe" "%BACKEND_DIR%\manage.py" collectstatic --noinput

call deactivate


:: ----------------------------------------------------------------------------
:: (4) FRONTEND SETUP (REACT)
:: ----------------------------------------------------------------------------
echo.
echo [INFO] ### Setting up Frontend (React) ###

cd /d "%FRONTEND_DIR%"

:: --- Install Dependencies and Build ---
echo [STEP] Installing Node.js dependencies...
call npm install

echo [STEP] Building React app for production...
call npm run build

:: --- Create Frontend IIS App Pool and Site ---
echo [STEP] Configuring IIS for Frontend...
%windir%\system32\inetsrv\appcmd.exe add apppool /name:%FRONTEND_SITE_NAME% /managedRuntimeVersion:"" /managedPipelineMode:Integrated
%windir%\system32\inetsrv\appcmd.exe add site /name:%FRONTEND_SITE_NAME% /bindings:http/*:%FRONTEND_PORT%: /physicalPath:"%FRONTEND_DIR%\build"

:: --- Create web.config for React with Reverse Proxy ---
echo [STEP] Creating web.config for React with URL Rewrite rules...
(
    echo ^<?xml version="1.0" encoding="UTF-8"?^>
    echo ^<configuration^>
    echo   ^<system.webServer^>
    echo     ^<rewrite^>
    echo       ^<rules^>
    echo         ^<rule name="Proxy to API" stopProcessing="true"^>
    echo           ^<match url="^api/(.*)" /^>
    echo           ^<action type="Rewrite" url="http://localhost:%BACKEND_PORT%/api/{R:1}" /^>
    echo         ^</rule^>
    echo         ^<rule name="React Router" stopProcessing="true"^>
    echo           ^<match url=".*" /^>
    echo           ^<conditions logicalGrouping="MatchAll"^>
    echo             ^<add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" /^>
    echo             ^<add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" /^>
    echo           ^</conditions^>
    echo           ^<action type="Rewrite" url="/" /^>
    echo         ^</rule^>
    echo       ^</rules^>
    echo     ^</rewrite^>
    echo     ^<staticContent^>
    echo       ^<mimeMap fileExtension=".json" mimeType="application/json" /^>
    echo     ^</staticContent^>
    echo   ^</system.webServer^>
    echo ^</configuration^>
) > "%FRONTEND_DIR%\build\web.config"


:: ----------------------------------------------------------------------------
:: (5) FINAL STEPS
:: ----------------------------------------------------------------------------
echo.
echo [INFO] ### Finalizing Setup ###

:: --- Open Firewall Port ---
echo [STEP] Opening firewall port %FRONTEND_PORT% for frontend access...
netsh advfirewall firewall show rule name="LMS Frontend Port" >nul
if %errorlevel%==0 (
    echo [INFO] Firewall rule already exists.
) else (
    netsh advfirewall firewall add rule name="LMS Frontend Port" dir=in action=allow protocol=TCP localport=%FRONTEND_PORT%
)

:: --- Restart IIS Sites ---
echo [STEP] Restarting IIS sites...
%windir%\system32\inetsrv\appcmd.exe stop site "%BACKEND_SITE_NAME%"
%windir%\system32\inetsrv\appcmd.exe start site "%BACKEND_SITE_NAME%"
%windir%\system32\inetsrv\appcmd.exe stop site "%FRONTEND_SITE_NAME%"
%windir%\system32\inetsrv\appcmd.exe start site "%FRONTEND_SITE_NAME%"

echo.
echo [SUCCESS] LMS Deployment is complete!
echo.
echo   Frontend is available at: http://localhost:%FRONTEND_PORT%
echo   Backend is running on port: %BACKEND_PORT%
echo.
echo   NEXT STEPS:
echo   1. Open IIS Manager to check site status and bindings.
echo   2. Run 'manage.py createsuperuser' to create your first admin account:
echo      cd /d %BACKEND_DIR%
echo      call %VENV_DIR%\Scripts\activate.bat
echo      python manage.py createsuperuser
echo.

endlocal
