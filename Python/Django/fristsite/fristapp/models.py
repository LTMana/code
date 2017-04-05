from django.db import models

# Create your models here.


class People(models.Model):
    name = models.CharField(blank=True, null=True, max_length=200)
    job = models.CharField(blank=True, null=True, max_length=200)

    def __str__(self):
        return self.name


class Aritcle(models.Model):
    headline = models.CharField(blank=True, null=True, max_length=500)
    content = models.TextField(blank=True, null=True)
    TAG_CHOICES = (
        ('tech', 'Tech'),
        ('life', 'Life'),
    )
    tag = models.CharField(blank=True, null=True,
                           max_length=5, choices=TAG_CHOICES)

    def __str__(self):
        return self.headline
