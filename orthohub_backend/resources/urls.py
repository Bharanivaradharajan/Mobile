from django.urls import path
from .views import DoctorListView, SummarizerView # and your other views...

urlpatterns = [
    path('doctor/', DoctorListView.as_view(), name='doctor-list'),
    
    # path('resources/', ResourceListView.as_view(), name='resource-list'),
]