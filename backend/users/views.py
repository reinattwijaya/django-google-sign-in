from django.shortcuts import render
from google.oauth2 import id_token
from google.auth.transport import requests
from django.http import JsonResponse
from rest_framework.views import APIView
from rest_framework import permissions
from rest_framework.response import Response 

# Create your views here.

CLIENT_ID = "952150031288-70et6ee38ku9fq6t3s65g4r68pjrl6p3.apps.googleusercontent.com"

class GoogleOauth(APIView):
   permission_classes=[permissions.AllowAny]
   def post(self,request):
    token = request.data['idToken'] # Get the authorization code
    email = ""
    try:
        # Specify the CLIENT_ID of the app that accesses the backend:
        idinfo = id_token.verify_oauth2_token(token, requests.Request(), CLIENT_ID)

        # Or, if multiple clients access the backend server:
        # idinfo = id_token.verify_oauth2_token(token, requests.Request())
        # if idinfo['aud'] not in [CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3]:
        #     raise ValueError('Could not verify audience.')

        # If auth request is from a G Suite domain:
        # if idinfo['hd'] != GSUITE_DOMAIN_NAME:
        #     raise ValueError('Wrong hosted domain.')

        # ID token is valid. Get the user's Google Account ID from the decoded token.
        email = idinfo['email']
    except ValueError:
        # Invalid token
        pass
    
    # For simplicity, returning the token information as JSON, but in a real application,
    # you should handle this securely and according to your application's authentication flow
    print(email)
    return Response({"email": email},status=200)