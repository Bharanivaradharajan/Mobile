from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import MedicalResource
from .serializers import ResourceSerializer

# resources/views.py

from rest_framework import viewsets, filters # Add filters here

class ResourceViewSet(viewsets.ModelViewSet):
    serializer_class = ResourceSerializer
    queryset = MedicalResource.objects.all()
    
    # Add these two lines to enable the search functionality
    filter_backends = [filters.SearchFilter]
    search_fields = ['title', 'author'] 

    def get_queryset(self):
        queryset = MedicalResource.objects.all()
        resource_type = self.request.query_params.get('type')
        
        if resource_type:
            # This will filter specifically by the type sent from Flutter
            return queryset.filter(resource_type__iexact=resource_type)
        
        # If no type is sent, return an empty list to avoid mixing data
        return MedicalResource.objects.none()