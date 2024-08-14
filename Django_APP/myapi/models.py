from django.db import models

class Site(models.Model):
     id = models.CharField(max_length=10, primary_key=True)
     longitude = models.DecimalField(max_digits=10, decimal_places=4)
     latitude = models.DecimalField(max_digits=10, decimal_places=4)

class Product(models.Model):
     serialNumber = models.IntegerField(unique=True, null=False, primary_key=True)
     details = models.TextField(max_length=500, null=True)
     status = models.BooleanField(null=False)
     site = models.ForeignKey(Site, null=True, on_delete=models.SET_NULL)
