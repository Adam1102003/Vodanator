# Generated by Django 5.0.7 on 2024-07-24 09:45

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapi', '0003_remove_product_name'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='password',
            field=models.CharField(max_length=15),
        ),
    ]
