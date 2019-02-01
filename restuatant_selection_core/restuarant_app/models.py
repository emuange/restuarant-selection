# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models


# Create your models here.
class Restaurant(models.Model):
    name = models.CharField(max_length=120, unique=True)
    description = models.TextField()
    location = models.CharField(max_length=255)
    opening_time = models.CharField(max_length=150)
    image = models.ImageField(
        upload_to='res_photos/',
        default='res_photos/default.png'
    )

    def __str__(self):
        return self.name


class Review(models.Model):
    restaurant = models.ForeignKey(Restaurant, on_delete=models.PROTECT)
    name = models.CharField(max_length=255)
    review = models.TextField()

    def __str__(self):
        return self.review
