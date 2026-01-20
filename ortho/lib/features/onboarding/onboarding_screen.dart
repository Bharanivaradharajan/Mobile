import 'package:flutter/material.dart';
import 'package:ortho/features/homescreen/home_screen.dart';
import 'onboarding_model.dart';


class CarouselOnboarding extends StatefulWidget {
  const CarouselOnboarding({super.key});

  @override
  State<CarouselOnboarding> createState() => _CarouselOnboardingState();
}

class _CarouselOnboardingState extends State<CarouselOnboarding> {
  late PageController _pageController;
  double _pageOffset = 0;

  final List<OrthoCard> cards = [
    OrthoCard(
      title: "Orthopedic Knowledge",
      number: "",
      description: "Bones, joints, fractures & disorders explained clearly",
      color: const Color(0xFF64B5F6),
      image: "assets/onboarding/onboarding_2.png",
    ),
    OrthoCard(
      title: "AI Ortho Research",
      number: "",
      description: "NER, Summarizer & Predictor for medical research",
      color: const Color(0xFF81C784),
      image: "assets/onboarding/onboarding_1.png",
    ),
    OrthoCard(
      title: "Doctors & Specialists",
      number: "",
      description: "Find orthopaedicians by specialization & city",
      color: const Color(0xFF4FC3F7),
      image: "assets/onboarding/on.jpg",
    ),
    OrthoCard(
      title: "Implants & Resources",
      number: "",
      description: "Orthopedic implants, books & research papers",
      color: const Color(0xFFBA68C8),
      image: "assets/onboarding/onboarding_3.png",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85)
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page ?? 0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundGlow(),

            Column(
              children: [
                /// ───────── TOP AREA ─────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _goNext,
                      child: const Text("Skip"),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "ORTHO-HUB",
                  style: TextStyle(
                    letterSpacing: 6,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                /// ───────── CENTER AREA (TRUE CENTER) ─────────
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: size.width * 0.88,
                      height: size.height * 0.55,
                      child: _buildCarousel(),
                    ),
                  ),
                ),

                /// ───────── BOTTOM AREA ─────────
                _buildIndicator(),

                const SizedBox(height: 18),

                if (_pageOffset.round() == cards.length - 1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cards.last.color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _goNext,
                    child: const Text("Get Started"),
                  ),

                const SizedBox(height: 12),

                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Educational & clinical insights only.\nNot for diagnosis.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// BACKGROUND GLOW
  Widget _buildBackgroundGlow() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            cards[_pageOffset.round()].color.withOpacity(0.18),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// CENTERED CAROUSEL
  Widget _buildCarousel() {
    return PageView.builder(
      controller: _pageController,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        double progress = index - _pageOffset;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(progress * 0.35)
            ..translate(progress * 30),
          alignment: Alignment.center,
          child: Opacity(
            opacity: (1 - progress.abs()).clamp(0.5, 1.0),
            child: _buildImageCard(cards[index], progress),
          ),
        );
      },
    );
  }

  /// IMAGE-FILLED CARD
  Widget _buildImageCard(OrthoCard card, double progress) {
    double scale = 1 - (progress.abs() * 0.12);

    return Transform.scale(
      scale: scale,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(card.image, fit: BoxFit.cover)),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: card.color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.number,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    card.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.75),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// INDICATOR
  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(cards.length, (index) {
        double active = (1 - (index - _pageOffset).abs()).clamp(0, 1);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 2,
          width: 22 + (22 * active),
          decoration: BoxDecoration(
            color: active > 0.5 ? cards[index].color : Colors.white12,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  void _goNext() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const OrthoHubShell()),
  );
}

}
