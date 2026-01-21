import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ortho/features/homescreen/home_screen.dart'; // Ensure path is correct
import 'onboarding_model.dart';

class CarouselOnboarding extends StatefulWidget {
  const CarouselOnboarding({super.key});

  @override
  State<CarouselOnboarding> createState() => _CarouselOnboardingState();
}

class _CarouselOnboardingState extends State<CarouselOnboarding> {
  late PageController _pageController;
  double _pageOffset = 0;
  Timer? _autoTimer;
  int _currentPage = 0;

  final List<OrthoCard> cards = [
    OrthoCard(
      title: "Orthopedic Knowledge",
      number: "01",
      description: "Bones, joints, fractures & disorders explained with clinical precision.",
      color: const Color(0xFF6366F1), // Electric Indigo
      image: "assets/onboarding/onboarding_2.png",
    ),
    OrthoCard(
      title: "AI Research Tools",
      number: "02",
      description: "Utilize NER & Predictor models for advanced medical data processing.",
      color: const Color(0xFF10B981), // Emerald
      image: "assets/onboarding/onboarding_1.png",
    ),
    OrthoCard(
      title: "Specialist Network",
      number: "03",
      description: "Connect with verified orthopedic surgeons across major medical hubs.",
      color: const Color(0xFFF59E0B), // Amber
      image: "assets/onboarding/on.jpg",
    ),
    OrthoCard(
      title: "Clinical Resources",
      number: "04",
      description: "Access curated implants, research papers, and academic publications.",
      color: const Color(0xFFEC4899), // Pink
      image: "assets/onboarding/onboarding_3.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82)
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page ?? 0;
        });
      });
    
    // Start Auto Carousel
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < cards.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final activeColor = cards[_pageOffset.round()].color;

    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // 1. Dynamic Background Mesh Glow
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.2),
                radius: 1.5,
                colors: [
                  activeColor.withOpacity(0.12),
                  const Color(0xFF030708),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// ───────── TOP BAR ─────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "RUSA 2.0",
                        style: TextStyle(
                          color: Colors.white30,
                          letterSpacing: 3,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _goNext,
                        child: Text(
                          "SKIP",
                          style: TextStyle(color: activeColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                
                // Title Section
                const Text(
                  "UNIVERSITY OF MADRAS",
                  style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 4),
                ),
                const SizedBox(height: 8),
                const Text(
                  "ORTHO-HUB",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),

                /// ───────── CAROUSEL AREA ─────────
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => _currentPage = index,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      double progress = index - _pageOffset;
                      return _buildFuturisticCard(cards[index], progress);
                    },
                  ),
                ),

                /// ───────── BOTTOM CONTROLS ─────────
                _buildIndicator(activeColor),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: _goNext,
                      child: Text(
                        _pageOffset.round() == cards.length - 1 ? "INITIALIZE HUB" : "CONTINUE",
                        style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Clinical Decision Support System\nData Integrity & Encryption Active",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.white24, height: 1.5),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturisticCard(OrthoCard card, double progress) {
    // 3D Rotation and Scaling
    final rotation = progress * 0.4;
    final scale = 1.0 - (progress.abs() * 0.1);

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(rotation),
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: card.color.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 20),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                // Image
                Positioned.fill(
                  child: Image.asset(card.image, fit: BoxFit.cover),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.number,
                        style: TextStyle(
                          color: card.color.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        card.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Glass-morphism Border
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(Color activeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(cards.length, (index) {
        double active = (1 - (index - _pageOffset).abs()).clamp(0, 1);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 4,
          width: 8 + (24 * active),
          decoration: BoxDecoration(
            color: active > 0.5 ? activeColor : Colors.white10,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              if (active > 0.5) 
                BoxShadow(color: activeColor.withOpacity(0.5), blurRadius: 8)
            ],
          ),
        );
      }),
    );
  }

  void _goNext() {
    _autoTimer?.cancel();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const OrthoHubShell(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}