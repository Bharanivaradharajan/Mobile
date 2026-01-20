import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import 'auth_screen.dart';
// ignore: unused_import
import 'package:video_player/video_player.dart';
import 'package:lottie/lottie.dart';

// 1. THE MAIN SHELL - This holds the persistent Title Bar and Navbar
class OrthoHubShell extends StatefulWidget {
  const OrthoHubShell({super.key});

  @override
  State<OrthoHubShell> createState() => _OrthoHubShellState();
}

class _OrthoHubShellState extends State<OrthoHubShell> {
  int _selectedTab = 0;

  // Pages list - swapping these preserves the AppBar and Navbar
  final List<Widget> _pages = [
    const OrthoHomeScreen(), // Your main dashboard
    const Center(
      child: Text("AI Research Engine", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Implants Catalog", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Saved Resources", style: TextStyle(color: Colors.white)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      extendBody: true, // Content scrolls behind the floating navbar
      // PERSISTENT TITLE BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.hub, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              "OrthoHub",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
          ],
        ),
        // Inside _OrthoHubShellState -> AppBar actions:
actions: [
  IconButton(
    icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    },
  ),
],
      ),

      // DYNAMIC BODY
      body: IndexedStack(index: _selectedTab, children: _pages),

      // PERSISTENT FLOATING NAVBAR
      bottomNavigationBar: _buildFloatingNavbar(),
    );
  }

  Widget _buildFloatingNavbar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 25),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: BottomNavigationBar(
            currentIndex: _selectedTab,
            onTap: (index) => setState(() => _selectedTab = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed, // Fixed is best for 5 items
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.white30,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined),
                label: 'Doctors',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.psychology_outlined),
                label: 'AI',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_stories_outlined),
                label: 'Resources',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 2. THE HOME SCREEN CONTENT
class OrthoHomeScreen extends StatefulWidget {
  const OrthoHomeScreen({super.key});

  @override
  State<OrthoHomeScreen> createState() => _OrthoHomeScreenState();
}

class _OrthoHomeScreenState extends State<OrthoHomeScreen> {
  final PageController _carouselController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_carouselController.hasClients) {
        int next = (_currentPage + 1) % 3;
        _carouselController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCarousel(),
          const SizedBox(height: 24),
          _buildSectionTitle("Orthopaedic Categories"),
          const OrthoBentoGrid(),
          const SizedBox(height: 32),
          _buildSectionTitle("AI Research Engine"),
          const AIEngineSection(),
          const SizedBox(height: 32),
          _buildSectionTitle("Latest Implants"),
          const ImplantPromotionCard(),
          const SizedBox(height: 32),
          _buildSectionTitle("Resource Library"),
          const ResourceScroll(),
          const InnovationFooter(),
          const SizedBox(height: 100), // Space for floating navbar
        ],
      ),
    );
  }

  Widget _buildHeroCarousel() {
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          // 1. The Background Images
          PageView(
            controller: _carouselController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              _heroSlide(
                "https://images.unsplash.com/photo-1612888262725-6b300edf916c?q=80&w=1171",
              ),
              _heroSlide(
                "https://images.unsplash.com/photo-1597764690523-15bea4c581c9?q=80&w=1170",
              ),
              _heroSlide(
                "https://images.unsplash.com/photo-1624716472114-a7c5f18ac832?q=80&w=1172",
              ),
            ],
          ),

          // 2. The Dark Gradient Overlay (for readability)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // 3. CENTERED TITLE & SUBTITLE
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ORTHOHUB",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8,
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ).withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "NEXT-GEN CLINICAL INTELLIGENCE",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Dot Indicator (Right Aligned)
          Positioned(
            bottom: 30,
            right: 20,
            child: Row(children: List.generate(3, (index) => _buildDot(index))),
          ),
        ],
      ),
    );
  }

  Widget _heroSlide(String url) => Image.network(url, fit: BoxFit.cover);

  Widget _buildDot(int index) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 4,
    width: _currentPage == index ? 24 : 8,
    margin: const EdgeInsets.only(right: 4),
    decoration: BoxDecoration(
      color: _currentPage == index ? Colors.blueAccent : Colors.white24,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

// 3. ENHANCED BENTO GRID WITH TRENDING POPUPS
class OrthoBentoGrid extends StatelessWidget {
  const OrthoBentoGrid({super.key});

  void _showTrendingPop(
    BuildContext context,
    String title,
    String content,
    Color color,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Trending",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) => Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.2), blurRadius: 40),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome, color: color, size: 40),
                const SizedBox(height: 16),
                Text(
                  "TRENDING: $title",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CLOSE"),
                ),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (context, anim, __, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
        child: FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: _bentoItem(
                  context,
                  "Joints",
                  "Arthroplasty Insights",
                  Icons.blur_on_rounded,
                  200,
                  Colors.blueAccent,
                  "92% Robotic Success",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    _bentoItem(
                      context,
                      "Trauma",
                      "Acute Care",
                      Icons.emergency_rounded,
                      94,
                      Colors.redAccent,
                      "New Bio-Glass",
                    ),
                    const SizedBox(height: 12),
                    _bentoItem(
                      context,
                      "Pediatrics",
                      "Growth Care",
                      Icons.child_care_rounded,
                      94,
                      Colors.orangeAccent,
                      "EOS Low-Dose",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bentoItem(
            context,
            "Spine & Sports",
            "Recovery Research",
            Icons.reorder_rounded,
            110,
            Colors.tealAccent,
            "AI Posture Sensors",
            isFull: true,
          ),
        ],
      ),
    );
  }

  Widget _bentoItem(
    BuildContext context,
    String title,
    String sub,
    IconData icon,
    double h,
    Color color,
    String trend, {
    bool isFull = false,
  }) {
    bool isSmall = h < 100;
    return GestureDetector(
      onTap: () => _showTrendingPop(
        context,
        title,
        "Latest breakthrough in $title involves $trend specifically designed for 2026 clinical standards.",
        color,
      ),
      child: Container(
        height: h,
        width: isFull ? double.infinity : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(isSmall ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: color, size: isSmall ? 22 : 28),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          trend.split(' ').last,
                          style: TextStyle(
                            color: color,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isSmall ? 14 : 17,
                          ),
                        ),
                        Text(
                          sub,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white30, fontSize: 10),
                        ),
                      ],
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
}

// 4. SUB-SECTIONS (AI, Implants, Footer)
class AIEngineSection extends StatelessWidget {
  const AIEngineSection({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: [
          _aiCard("NER ENGINE", Icons.psychology, Colors.purpleAccent),
          _aiCard("SUMMARIZER", Icons.summarize, Colors.orangeAccent),
          _aiCard("PREDICTOR", Icons.query_stats, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _aiCard(String t, IconData i, Color c) => Container(
    width: 200,
    margin: const EdgeInsets.only(right: 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF111111),
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(i, color: c),
        const Spacer(),
        Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}


class ImplantPromotionCard extends StatefulWidget {
  const ImplantPromotionCard({super.key});
  @override
  State<ImplantPromotionCard> createState() => _ImplantPromotionCardState();
}

class _ImplantPromotionCardState extends State<ImplantPromotionCard> {
  VideoPlayerController? _controller;
  bool _shouldShowMedia = false;

  @override
  void initState() {
    super.initState();
    // 1. DELAY INITIALIZATION 
    // This prevents the "Skipped 75 frames" error by waiting for the UI to settle
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _initializeVideo();
    });
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.asset('assets/onboarding/orth.mp4')
      ..initialize().then((_) {
        _controller?.setVolume(0);
        _controller?.setLooping(true);
        _controller?.play();
        setState(() { _shouldShowMedia = true; });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF111111), // Solid background while loading
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Only render video/lottie after the delay to save main thread cycles
              if (_shouldShowMedia && _controller != null && _controller!.value.isInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),

              // Use a simpler overlay instead of heavy BackdropFilter if jank persists
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Implant Integration", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Hardware accelerated", 
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ResourceScroll extends StatelessWidget {
  const ResourceScroll({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: [
          _resItem("PubMed"),
          _resItem("Surgical Atlas"),
          _resItem("Ortho Today"),
        ],
      ),
    );
  }

  Widget _resItem(String t) => Container(
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        t,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    ),
  );
}

class InnovationFooter extends StatelessWidget {
  const InnovationFooter({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          "ORTHOHUB v2.0.4 • 2026",
          style: TextStyle(color: Colors.white12, fontSize: 10),
        ),
      ),
    );
  }
}
