# Generated by Django 5.0.7 on 2024-07-22 23:04

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapi', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='product',
            name='details',
            field=models.TextField(max_length=500, null=True),
        ),
        migrations.AlterField(
            model_name='site',
            name='id',
            field=models.CharField(max_length=10, primary_key=True, serialize=False),
        ),
    ]
