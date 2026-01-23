import os
from django.conf import settings
from rest_framework import viewsets, generics, filters, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated

from .models import MedicalResource, Doctor
from .serializers import ResourceSerializer, DoctorSerializer

# --- CUSTOM MODEL SERVICE LAYER ---
# This class acts as a placeholder for your future model logic
class OrthoModelService:
    _instance = None
    _model = None

    @classmethod
    def get_instance(cls):
        if cls._instance is None:
            cls._instance = OrthoModelService()
            # In the future, load your model here:
            # cls._model = joblib.load('path/to/model.pkl') or torch.load(...)
            print("--- Ortho Custom Model Service Initialized ---")
        return cls._instance

    def predict_summary(self, text):
        # REPLACE THIS: Logic to process text through your custom model
        return f"Summary from Custom Model: {text[:50]}..."

    def extract_ner(self, text):
        # REPLACE THIS: Logic to extract entities (Anatomy, Implants, etc.)
        return [
            {"text": "Sample Anatomy", "type": "ANATOMY"},
            {"text": "Sample Implant", "type": "IMPLANT"}
        ]

# Initialize the service once
ortho_service = OrthoModelService.get_instance()


# --- EXISTING VIEWS (MODIFIED) ---

class ResourceViewSet(viewsets.ModelViewSet):
    serializer_class = ResourceSerializer
    queryset = MedicalResource.objects.all()
    filter_backends = [filters.SearchFilter]
    search_fields = ['title', 'author'] 

    def get_queryset(self):
        queryset = MedicalResource.objects.all()
        resource_type = self.request.query_params.get('type')
        if resource_type:
            return queryset.filter(resource_type__iexact=resource_type)
        return MedicalResource.objects.none()

class DoctorListView(generics.ListAPIView):
    queryset = Doctor.objects.all()
    serializer_class = DoctorSerializer
    permission_classes = [AllowAny]


# --- NEW CUSTOM MODEL ENDPOINTS ---

class SummarizerView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        text = request.data.get("text", "")
        if not text:
            return Response({"error": "No text provided"}, status=status.HTTP_400_BAD_REQUEST)
        
        # Use your custom service instead of GenAI
        summary = ortho_service.predict_summary(text)
        return Response({"summary": summary}, status=status.HTTP_200_OK)

class NERExtractorView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        text = request.data.get("text", "")
        if not text:
            return Response({"error": "No text provided"}, status=status.HTTP_400_BAD_REQUEST)
        
        # Use your custom service for entity extraction
        entities = ortho_service.extract_ner(text)
        return Response({"entities": entities}, status=status.HTTP_200_OK)