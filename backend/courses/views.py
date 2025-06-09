from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
# from .models import Course  # Assuming you create a Course model
# from .serializers import CourseSerializer # Assuming you create a serializer
from users.permissions import IsAdminUser

class CourseViewSet(viewsets.ModelViewSet):
    # queryset = Course.objects.all()
    # serializer_class = CourseSerializer

    def get_permissions(self):
        if self.action in ['create', 'update', 'partial_update', 'destroy']:
            permission_classes = [IsAuthenticated, IsAdminUser]
        else:
            permission_classes = [IsAuthenticated]
        return [permission() for permission in permission_classes]
