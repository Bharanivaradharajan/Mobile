from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User

class CustomUserAdmin(UserAdmin):
    # This ensures your new fields show up when editing a user
    fieldsets = UserAdmin.fieldsets + (
        ('Clinical Meta', {'fields': ('role', 'institution')}),
    )
    # This adds the role column to the main list view
    list_display = ['username', 'email', 'role', 'is_staff']

admin.site.register(User, CustomUserAdmin)