import 'package:flutter/material.dart';
import 'package:ortho/features/homescreen/ai_tool_dynamic_page.dart';

class AIResearchPage extends StatelessWidget {
  const AIResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // This empty sliver acts as a safe-area spacer to prevent content 
          // from hiding under the transparent title bar.
          const SliverToBoxAdapter(
            child: SizedBox(height: 12), 
          ),

          // THE PAGE TITLES
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CLINICAL INTELLIGENCE",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "AI Power Tools",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Advanced neural models tailored for orthopaedic data processing and predictive analytics under the RUSA 2.0 initiative.",
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

          // THE TOOLS LIST
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildAICard(
                  title: "NER Engine",
                  subtitle: "Named Entity Recognition",
                  description: "Extracts anatomical landmarks, implant types, and clinical findings from raw text.",
                  icon: Icons.psychology_outlined,
                  colors: [const Color(0xFFA855F7), const Color(0xFF3B82F6)],
                  tag: "NLP v3.0",
                ),
                const SizedBox(height: 20),
                _buildAICard(
                  title: "Summarizer",
                  subtitle: "Clinical Text Distillation",
                  description: "Condenses lengthy operative notes into concise, actionable summaries for rounds.",
                  icon: Icons.auto_awesome_outlined,
                  colors: [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
                  tag: "BERT-based",
                ),
                const SizedBox(height: 20),
                _buildAICard(
                  title: "Predictor",
                  subtitle: "Outcome Prediction Model",
                  description: "Forecasts patient recovery timelines based on historical orthopaedic datasets.",
                  icon: Icons.timeline_outlined,
                  colors: [const Color(0xFF10B981), const Color(0xFF065F46)],
                  tag: "ML Engine",
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAICard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required List<Color> colors,
    required String tag,
  }) {
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
                builder: (context) => AIToolPage(
                  toolName: title,
                  themeColors: colors,
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
                          tag,
                          style: TextStyle(color: colors[0], fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: colors[0].withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text("ACCESS TOOL", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 14),
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