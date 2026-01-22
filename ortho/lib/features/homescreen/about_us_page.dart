import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Futuristic Background Accents
          Positioned(
            top: -100,
            right: -50,
            child: _glowCircle(const Color(0xFF6366F1).withOpacity(0.05)),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHeader(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectOverview(),
                      const SizedBox(height: 50),
                      _sectionTitle("THE RESEARCH FACULTY"),
                      _buildTeamGrid(),
                      const SizedBox(height: 50),
                      _sectionTitle("INSTITUTIONAL PARTNERS"),
                      _buildInstitutionCard(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Scroll Indicator / Close Hint
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Text("SWIPE DOWN TO RETURN", 
                    style: TextStyle(color: Colors.white12, fontSize: 9, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white24, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      backgroundColor: const Color(0xFF030708),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            // Mesh background effect
            Opacity(
              opacity: 0.3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "PROJECT ARCHITECTURE",
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    letterSpacing: 5,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "AI-INTEGRATED\nORTHOPAEDICS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                  ),
                  child: const Text(
                    "RUSA 2.0 INFRASTRUCTURE",
                    style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EXECUTIVE SUMMARY",
            style: TextStyle(color: Color(0xFF6366F1), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 12),
          const Text(
            "Smart Clinical Intelligence System",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "RUSA 2.0-RI & QI-BioMaterials-NAo Informatics on the role of Nano-HAP in orthopedic",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.7),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamGrid() {
    return Column(
      children: [
        _animatedProfileCard(
          "Project Coordinator", 
          "Dr. B. Lavanya", 
          "Associate Professor Dept.of.Computer Science UNOM", 
          Icons.biotech_rounded,
          const Color(0xFF10B981), // Emerald
        ),
        _animatedProfileCard(
          "Intern-Mobile Application Developement", 
          "V.Bharani Dharan", 
          "• Full-Stack Mobile Application Developement", 
          Icons.terminal_rounded,
          const Color(0xFFF59E0B), // Amber
        ),
        _animatedProfileCard(
          "Research Scholar", 
          "M.Sasipriya", 
          "PhD Researcher • Data Analysis - Web Developement", 
          Icons.auto_awesome_mosaic_rounded,
          const Color(0xFFEC4899), // Pink
        ),
      ],
    );
  }

  Widget _animatedProfileCard(String role, String name, String sub, IconData icon, Color accentColor) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            child: AnimatedScale(
              scale: isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.15),
                      accentColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.toUpperCase(), 
                            style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                          ),
                          const SizedBox(height: 5),
                          Text(
                            name, 
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sub, 
                            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstitutionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_rounded, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Text("UNIVERSITY OF MADRAS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Rashtriya Uchchatar Shiksha Abhiyan (RUSA 2.0)", 
            style: TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 16),
          Text(
            "The infrastructure and data synchronization for this ecosystem are powered by RUSA funding, dedicated to promoting excellence in medical research and higher education technologies.",
            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 12, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(Color color) => Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 150,
              spreadRadius: 50,
            ),
          ],
        ),
      );

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 20),
        child: Text(
          title, 
          style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3)
        ),
      );
}