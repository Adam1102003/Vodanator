# Generated by Django 5.0.7 on 2024-07-22 23:06

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('myapi', '0002_alter_product_details_alter_site_id'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='product',
            name='name',
        ),
    ]