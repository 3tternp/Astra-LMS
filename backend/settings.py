# backend/settings.py
import os
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': os.getenv('lmsdb'),
    'USER': os.getenv('lmsadmin'),
    'PASSWORD': os.getenv('lmspass'),
    'HOST': os.getenv('localhost'),
    'PORT': '5432',
  }
}
