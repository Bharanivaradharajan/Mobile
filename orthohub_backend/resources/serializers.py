from rest_framework import serializers
from .models import MedicalResource
from .models import Doctor
class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'

class ResourceSerializer(serializers.ModelSerializer):
    thumbnail = serializers.SerializerMethodField()

    class Meta:
        model = MedicalResource
        fields = '__all__'

    def get_thumbnail(self, obj):
        if obj.thumbnail:
            request = self.context.get('request')
            if request is not None:
                # This automatically adds http://192.168.2.163:8000/ to the path
                return request.build_absolute_uri(obj.thumbnail.url)
            return obj.thumbnail.url
        return None