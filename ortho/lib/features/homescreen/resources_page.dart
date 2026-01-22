import 'package:flutter/material.dart';
import 'package:ortho/features/homescreen/dynamic_resource_listing_page.dart';
// Ensure this file exists

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Ambient Glow Background for visual continuity
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withOpacity(0.05),
              ),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Spacer to prevent content from touching the status bar
              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // HEADER SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "KNOWLEDGE HUB",
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Medical Resources",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Access a curated library of orthopaedic literature, academic books, and global research databases.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // RESOURCES LIST (Interactive Cards)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildResourceCard(
                      context: context,
                      title: "Digital Library",
                      subtitle: "Core Orthopaedic Books",
                      description: "Browse a collection of standard textbooks and clinical guides available for purchase or digital reading.",
                      icon: Icons.auto_stories_outlined,
                      colors: [const Color(0xFF10B981), const Color(0xFF064E3B)],
                      count: "45+ Books",
                    ),
                    const SizedBox(height: 20),
                    _buildResourceCard(
                      context: context,
                      title: "Research Portal",
                      subtitle: "Common Research Papers",
                      description: "Explore locally archived and open-access research papers tailored to recent surgical advancements.",
                      icon: Icons.science_outlined,
                      colors: [const Color(0xFF3B82F6), const Color(0xFF1E3A8A)],
                      count: "120+ Papers",
                    ),
                    const SizedBox(height: 20),
                    _buildResourceCard(
                      context: context,
                      title: "PubMed Database",
                      subtitle: "Indexed Clinical Archive",
                      description: "Direct interface to browse PubMed research articles with indexed PMID data and abstract previews.",
                      icon: Icons.storage_rounded,
                      colors: [const Color(0xFFF59E0B), const Color(0xFF78350F)],
                      count: "Global Feed",
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- REUSABLE CARD WIDGET WITH NAVIGATION ---
  Widget _buildResourceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required List<Color> colors,
    required String count,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        return GestureDetector(
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          
          // DYNAMIC NAVIGATION LOGIC
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DynamicResourceListing(
                  key: UniqueKey(),
                  category: title,
                  themeColor: colors[0],
                ),
              ),
            );
          },

          child: AnimatedScale(
            scale: isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    colors[0].withOpacity(0.12),
                    colors[1].withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: colors[0].withOpacity(0.15), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors[0].withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: colors[0], size: 24),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          count,
                          style: TextStyle(
                            color: colors[0],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors[0].withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "EXPLORE DATABASE",
                        style: TextStyle(
                          color: colors[0].withOpacity(0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: colors[0].withOpacity(0.8), size: 14),
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