from django.contrib import admin
from django.urls import include, path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from accounts.views import RegisterView
from accounts.serializers import CustomTokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView # We'll create this next
from resources.views import ResourceViewSet, SummarizerView
from rest_framework.routers import DefaultRouter
from django.conf import settings
from django.conf.urls.static import static



router = DefaultRouter()
router.register(r'resources', ResourceViewSet, basename='resources')

class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

urlpatterns = [
    path('admin/', admin.site.urls),
    # SIGNUP
    path('api/register/', RegisterView.as_view(), name='auth_register'),
    # LOGIN (Returns the Token + Role)
    path('api/login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/', include(router.urls)),
    path('api/', include('resources.urls')),
    
    
]
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)