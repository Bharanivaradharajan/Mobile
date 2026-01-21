import 'package:flutter/material.dart';
import 'ortho_section_detail.dart';

class OrthoHubPage extends StatelessWidget {
  const OrthoHubPage({super.key});

  final List<Map<String, dynamic>> sections = const [
    {"title": "Spine & Vertebrae", "icon": Icons.align_vertical_center_rounded, "items": "24 Topics", "color": Color(0xFF6366F1)},
    {"title": "Joint Reconstruction", "icon": Icons.animation_rounded, "items": "18 Topics", "color": Color(0xFF8B5CF6)},
    {"title": "Trauma & Fractures", "icon": Icons.handyman_outlined, "items": "32 Topics", "color": Color(0xFFEC4899)},
    {"title": "Sports Medicine", "icon": Icons.directions_run_rounded, "items": "15 Topics", "color": Color(0xFF3B82F6)},
    {"title": "Pediatric Ortho", "icon": Icons.child_care_rounded, "items": "12 Topics", "color": Color(0xFF10B981)},
    {"title": "Hand & Wrist", "icon": Icons.pan_tool_alt_outlined, "items": "20 Topics", "color": Color(0xFFF59E0B)},
    {"title": "Foot & Ankle", "icon": Icons.pest_control_rodent_outlined, "items": "14 Topics", "color": Color(0xFF06B6D4)},
    {"title": "Oncology (Bone)", "icon": Icons.biotech_rounded, "items": "10 Topics", "color": Color(0xFFEF4444)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Background Aesthetic Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.03),
              ),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              
              // HEADER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CLINICAL SPECIALTIES", 
                        style: TextStyle(
                          color: Color(0xFF6366F1), 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 2.5
                        )
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Orthopaedics", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 32, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Explore specialized clinical procedures, surgical illustrations, and curated medical content.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5), 
                          fontSize: 14, 
                          height: 1.5
                        )
                      ),
                    ],
                  ),
                ),
              ),

              // THE AESTHETIC GRID
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95, // Slightly taller for more elegance
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildAestheticCard(context, sections[index]),
                    childCount: sections.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAestheticCard(BuildContext context, Map<String, dynamic> section) {
    final Color sectionColor = section['color'];

    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrthoSectionDetail(sectionTitle: section['title'])
              ),
            );
          },
          child: AnimatedScale(
            scale: isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    sectionColor.withOpacity(0.12),
                    sectionColor.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: sectionColor.withOpacity(0.15), 
                  width: 1
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sectionColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(section['icon'], color: sectionColor, size: 22),
                  ),
                  
                  // Label Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section['title'], 
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14,
                          height: 1.2
                        )
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          section['items'], 
                          style: TextStyle(
                            color: sectionColor.withOpacity(0.8), 
                            fontSize: 10, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}