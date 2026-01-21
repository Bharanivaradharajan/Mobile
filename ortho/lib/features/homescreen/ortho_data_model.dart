class OrthoArticle {
  final String section;      // e.g., "Spine & Vertebrae"
  final String title;        // e.g., "Lumber Spondylosis"
  final String description;
  final String? imageUrl;    // Path to your illustration
  final List<String> points; // Key surgical/clinical points

  OrthoArticle({
    required this.section,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.points,
  });
}