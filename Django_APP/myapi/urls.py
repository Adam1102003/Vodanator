from django.urls import path, include
from rest_framework import routers
from .views import SiteViewSet, ProductViewSet

router = routers.DefaultRouter()
router.register(r'products', ProductViewSet)
router.register(r'sites', SiteViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('products/get_product_by_serial/', ProductViewSet.as_view({'get': 'get_product_by_serial'})),
]
