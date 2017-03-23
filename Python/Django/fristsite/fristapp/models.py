from django.db import models

# Create your models here.


class People(models.Model):
    name = models.CharField(blank=True, null=True, max_length=200)
    job = models.CharField(blank=True, null=True, max_length=200)
