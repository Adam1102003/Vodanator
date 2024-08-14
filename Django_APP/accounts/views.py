from django.shortcuts import render
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.contrib.auth.hashers import make_password
from rest_framework import status
from .serializers import UserSerializer
from rest_framework.permissions import IsAuthenticated

@api_view(['GET']) 
@permission_classes([IsAuthenticated])  
def current_user(request):
    """
    Returns the data of the currently authenticated user.
    """
    user = UserSerializer(request.user)  
    return Response(user.data)  
