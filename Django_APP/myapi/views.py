from rest_framework import viewsets, status
from .serializers import ProductSerializer, siteSerializer
from .models import Product, Site
from rest_framework.decorators import action
from rest_framework.response import Response
from django.shortcuts import get_object_or_404

class ProductViewSet(viewsets.ModelViewSet):
    
    queryset = Product.objects.all()
  
    serializer_class = ProductSerializer

    @action(detail=False, methods=['get'])
    def get_product_by_serial(self, request):
        serial_number = request.query_params.get('serialNumber', None)
        
        if serial_number is not None:
            # Fetches the product with the specified serial number or returns 404 if not found
            product = get_object_or_404(Product, serialNumber=serial_number)
            
            serializer = ProductSerializer(product)
        
            return Response(serializer.data)
        else:
            # Returns an error response if the serial number is not provided
            return Response({'error': 'Serial number not provided'}, status=status.HTTP_400_BAD_REQUEST)

class SiteViewSet(viewsets.ModelViewSet):

    queryset = Site.objects.all()
    
    serializer_class = siteSerializer
