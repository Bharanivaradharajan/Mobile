import 'package:flutter/material.dart';

class ImplantTypeDetail {
  final String category;
  final String description;
  final List<String> subTypes;
  final IconData icon;
  final String imagePath;

  ImplantTypeDetail({
    required this.category,
    required this.description,
    required this.subTypes,
    required this.icon,
    required this.imagePath,
  });
}

class ImplantModel {
  final String id;
  final String name;
  final String material;
  final String manufacturer;
  final String imagePath;
  final Color accentColor; // New: Unique identity color

  ImplantModel({
    required this.id,
    required this.name,
    required this.material,
    required this.manufacturer,
    required this.imagePath,
    required this.accentColor,
  });
}

class ImplantsData {
  static const String definition = 
      "Orthopaedic implants are medical devices manufactured to replace a missing joint or bone or to support a damaged bone. Mainly fabricated using titanium alloys and stainless steel for bio-compatibility and strength.";

  static final List<ImplantTypeDetail> typeDetails = [
    ImplantTypeDetail(
      category: "Screws",
      description: "Designed to produce compression to mend bones, rotator cuffs, or torn labrums. They vary in size (4.5mm to 8.5mm) and resemble industrial hardware but with medical-grade precision.",
      subTypes: ["Compression Screws", "Reduction Screws", "Cannulated Screws"],
      icon: Icons.settings_suggest_outlined,
      imagePath: "assets/onboarding/screws.png", 
    ),
    ImplantTypeDetail(
      category: "Plates",
      description: "Internal splints holding bone fragments together. Since 1886, they have evolved into specialized categories based on the force they counteract.",
      subTypes: ["Buttress", "Neutralisation", "Bridging", "Tension", "Compression"],
      icon: Icons.straighten_outlined,
      imagePath: "assets/onboarding/plates.png", 
    ),
    ImplantTypeDetail(
      category: "Prostheses",
      description: "Used to replace entire missing joints or diseased bones. Typically applied in hip and knee replacements to restore mobility rapidly.",
      subTypes: ["Total Hip Stem", "Acetabular Cup", "Femoral Component"],
      icon: Icons.accessibility_new_rounded,
      imagePath: "assets/onboarding/prostheses.png", 
    ),
  ];

  static final List<ImplantModel> catalog24 = _generateCatalog();

  static List<ImplantModel> _generateCatalog() {
    final List<String> names = [
      "Small Fragment Locking", "Small Fragment Standard", "Large Fragment Safety Locking",
      "Cable Plate System", "Large Fragment Standard", "DHS DCS Pediatric",
      "Pelvic Implants Instruments", "Knee Osteotomy Plates", "Mini Fragment Implants",
      "Craniomaxillofacial Implants", "Pediatric Implants", "Headless Compression Cannulated Screws",
      "Rib Foot Implants", "Implants Removal Set", "Interlocking Nails",
      "Nails Wires Pins", "Hip Prosthesis", "Spine Surgery Implants",
      "General Instruments", "External Fixators", "Surgical Power Tools",
      "Arthroscopy ACL PCL", "Support Braces", "Veterinary Implants Instruments"
    ];

    final List<Color> neonPalette = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEC4899), // Pink
      const Color(0xFF8B5CF6), // Violet
    ];

    return List.generate(names.length, (index) {
      String rawName = names[index];
      String fileName = rawName.toLowerCase().replaceAll(' ', '-').replaceAll('/', '-').replaceAll('&', 'and');

      return ImplantModel(
        id: "RUSA-XP-${100 + index}",
        name: rawName,
        material: index % 2 == 0 ? "Titanium Alloy" : "316L Stainless Steel",
        manufacturer: ["Stryker", "DePuy Synthes", "Zimmer Biomet"][index % 3],
        imagePath: "assets/implants/$fileName.jpg",
        accentColor: neonPalette[index % neonPalette.length],
      );
    });
  }
}