# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.contrib import admin

from .models import Restaurant, Review


class ReviewInLine(admin.StackedInline):
    model = Review
    extra = 2


class RestaurantAdmin(admin.ModelAdmin):
    inlines = [ReviewInLine]


# Register your models here.
admin.site.register(Restaurant, RestaurantAdmin)
