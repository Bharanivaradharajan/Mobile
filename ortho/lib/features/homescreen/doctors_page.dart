import 'package:flutter/material.dart';
import 'doctor_data.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String selectedCity = "All";

  // List of glowing accent colors to rotate through the cards
  final List<Color> accentColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF10B981), // Emerald
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEC4899), // Pink
    const Color(0xFF8B5CF6), // Violet
  ];

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showDoctorDetails(DoctorModel doc, Color accentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDetailModal(doc, accentColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDoctors = selectedCity == "All"
        ? doctorData
        : doctorData.where((doc) => doc.city == selectedCity).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Background Aesthetic Glow
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "FACULTY NETWORK",
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Clinical Surgeons",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildPillFilter(),
                    ],
                  ),
                ),
              ),

              // DOCTORS LIST
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Assign a unique color based on index
                      final accentColor = accentColors[index % accentColors.length];
                      return _buildFuturisticCard(filteredDoctors[index], accentColor);
                    },
                    childCount: filteredDoctors.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillFilter() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: availableCities.length,
        itemBuilder: (context, index) {
          final city = availableCities[index];
          bool isSelected = selectedCity == city;
          return GestureDetector(
            onTap: () => setState(() => selectedCity = city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF6366F1) : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.white.withOpacity(0.07),
                ),
              ),
              child: Text(
                city,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFuturisticCard(DoctorModel doc, Color accentColor) {
    return StatefulBuilder(
      builder: (context, setCardState) {
        bool isHovered = false;
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTapDown: (_) => setCardState(() => isHovered = true),
            onTapUp: (_) => setCardState(() => isHovered = false),
            onTapCancel: () => setCardState(() => isHovered = false),
            onTap: () => _showDoctorDetails(doc, accentColor),
            child: AnimatedScale(
              scale: isHovered ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.12),
                      accentColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    // Profile Image with Glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 15)
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            doc.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, e, s) => Container(
                              width: 60, height: 60, color: Colors.white10,
                              child: Icon(Icons.person, color: accentColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doc.specialty.toUpperCase(),
                            style: TextStyle(
                              color: accentColor, 
                              fontSize: 10, 
                              fontWeight: FontWeight.bold, 
                              letterSpacing: 1.5
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.apartment_rounded, size: 12, color: Colors.white24),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  doc.hospital,
                                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white10, size: 14),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailModal(DoctorModel doc, Color accentColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
      decoration: BoxDecoration(
        color: const Color(0xFF07090C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 45, height: 4,
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 35),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.network(
                    doc.imageUrl, width: 100, height: 100, fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(doc.specialty, style: TextStyle(color: accentColor, fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _modalInfoBlock(Icons.verified_user_outlined, "Verified Specialist", doc.hospital, accentColor),
          const SizedBox(height: 20),
          _modalInfoBlock(Icons.hub_outlined, "Research Group", "RUSA 2.0 Network", accentColor),
          const SizedBox(height: 40),
          const Text(
            "CLINICAL INSIGHTS",
            style: TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 15),
          Text(
            "Leading surgical expert contributing to the University of Madras clinical framework. Focused on orthopedic biomechanics and data-driven patient recovery protocols.",
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15, height: 1.8),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(color: accentColor.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _launchURL(doc.websiteUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                elevation: 0,
              ),
              child: const Text("ACCESS DIGITAL PROFILE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modalInfoBlock(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 18),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white30, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}