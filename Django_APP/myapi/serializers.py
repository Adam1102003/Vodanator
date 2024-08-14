from rest_framework import serializers
from .models import Product,Site
from django.contrib.auth.hashers import make_password
# from rest_framework_simplejwt.views import TokenObtainPairView
# from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model=Product
        fields="__all__"

        
class siteSerializer(serializers.ModelSerializer):
    class Meta:
        model=Site
        fields="__all__"


