from django.db import models

class MedicalResource(models.Model):
    RESOURCE_TYPES = [
        ('BOOK', 'Textbook'),
        ('PUBMED', 'PubMed Article'),
        ('RESEARCH', 'Research Paper'),
    ]

    title = models.CharField(max_length=255)
    resource_type = models.CharField(max_length=10, choices=RESOURCE_TYPES)
    
    # Details
    author = models.CharField(max_length=255)
    edition = models.CharField(max_length=50, blank=True, null=True)
    description = models.TextField()
    
    # Media
    thumbnail = models.ImageField(upload_to='resources/thumbnails/', blank=True, null=True)
    cover_image_url = models.URLField(max_length=500, blank=True) # For external images
    
    # Links
    buy_url = models.URLField(max_length=500, blank=True, null=True)
    article_url = models.URLField(max_length=500, blank=True, null=True) # PubMed/Research link
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"[{self.resource_type}] {self.title}"


class Doctor(models.Model):
    name = models.CharField(max_length=255)
    specialty = models.CharField(max_length=255)
    city = models.CharField(max_length=100, default="Chennai")
    hospital = models.CharField(max_length=255)
    # Use ImageField if you want to upload files, or URLField for external links
    image_url = models.URLField(max_length=500, blank=True, null=True) 
    website_url = models.URLField(max_length=500, blank=True, null=True)

    def __str__(self):
        return self.name