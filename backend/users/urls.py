from django.urls import path
from .views import GoogleOauth
app_name = 'users'

from rest_framework.authtoken import views
urlpatterns = [
    path('google_oauth/', GoogleOauth.as_view()),
   ]