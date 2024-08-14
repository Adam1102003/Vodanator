import django_filters
from .models import Product,Site



class ProductFilter(django_filters.FilterSet):
    serialnumber = django_filters.NumberFilter(lookup_expr='iexact')
    status=django_filters.BooleanFilter(lookup_expr='iexact')
    class Meta:
        model = Product
        fields = ('serialnumber','status')


class SiteFilter(django_filters.FilterSet):
    id = django_filters.CharFilter(lookup_expr='iexact')
    longitude=django_filters.NumberFilter(lookup_expr='iexact')
    latitude=django_filters.NumberFilter(lookup_expr='iexact')
    class Meta:
        model=Site
        fields=('id','longitude','latitude')
                