from django.contrib import admin
from .models import MedicalResource
from django.contrib import admin
from .models import Doctor

@admin.register(Doctor)
class DoctorAdmin(admin.ModelAdmin):
    list_display = ('name', 'specialty', 'city', 'hospital')
    search_fields = ('name', 'specialty', 'city')

@admin.register(MedicalResource)
class MedicalResourceAdmin(admin.ModelAdmin):
    # This controls which columns you see in the list view
    list_display = ('title', 'resource_type', 'author', 'created_at')
    
    # This adds a sidebar filter on the right
    list_filter = ('resource_type',)
    
    # This adds a search bar at the top
    search_fields = ('title', 'author', 'description')