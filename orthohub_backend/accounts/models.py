from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

class User(AbstractUser):
    ROLE_CHOICES = [
        ('COMMON', 'Common People'),
        ('DOCTOR', 'Doctor'),
        ('STUDENT', 'Student'),
        ('PROFESSOR', 'Professor'),
    ]
    
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='COMMON')
    institution = models.CharField(max_length=255, blank=True, null=True)

    # Add these lines to fix the 'Reverse accessor' errors
    groups = models.ManyToManyField(
        Group,
        related_name="custom_user_set",  # Unique name to avoid clash
        blank=True,
        help_text="The groups this user belongs to.",
        verbose_name="groups",
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name="custom_user_permissions_set",  # Unique name to avoid clash
        blank=True,
        help_text="Specific permissions for this user.",
        verbose_name="user permissions",
    )

    def __str__(self):
        return f"{self.username} ({self.role})"