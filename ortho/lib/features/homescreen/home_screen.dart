import 'package:flutter/material.dart';
import 'package:ortho/features/homescreen/about_us_page.dart';
import 'package:ortho/features/homescreen/ai_research_page.dart';
import 'package:ortho/features/homescreen/ai_tool_dynamic_page.dart';
import 'package:ortho/features/homescreen/ortho_hub_page.dart';
import 'package:ortho/features/homescreen/ortho_implants_page.dart';
import 'package:ortho/features/homescreen/resources_page.dart';
import 'dart:ui';
import 'dart:async';
import 'blog_data.dart';
import 'auth_screen.dart';
// ignore: unused_import
import 'package:video_player/video_player.dart';
import 'long_form_data.dart';
import 'doctors_page.dart';
import 'package:flutter/services.dart';
// for HapticFeedback


// 1. THE MAIN SHELL - This holds the persistent Title Bar and Navbar
class OrthoHubShell extends StatefulWidget {
  const OrthoHubShell({super.key});

  @override
  State<OrthoHubShell> createState() => _OrthoHubShellState();
}

class _OrthoHubShellState extends State<OrthoHubShell> {
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    // Trigger the disclaimer exactly when the user lands in the app
    Future.delayed(const Duration(milliseconds: 500), () {
      showFuturisticDisclaimer(context);
    });
  }
  

  // Pages list - swapping these preserves the AppBar and Navbar
  final List<Widget> _pages = [
    const OrthoHomeScreen(),
    const DoctorsPage(),
    const AIResearchPage(),
    const ResourcesPage(),
    const OrthoHubPage(),
    const AuthScreen(),
    
     // Your main dashboard
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
  Route _createAboutRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AboutUsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curve),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      extendBody: false, // Content scrolls behind the floating navbar
      // PERSISTENT TITLE BAR
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
  onLongPress: () async {
    await HapticFeedback.heavyImpact(); // tactile pop
    Navigator.of(context).push(_createAboutRoute());
  },
  child: const AnimatedLogoWrapper(), // pulsing animated logo
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
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                label: 'Orthopedics',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class AnimatedLogoWrapper extends StatefulWidget {
  const AnimatedLogoWrapper({super.key});

  @override
  State<AnimatedLogoWrapper> createState() => _AnimatedLogoWrapperState();
}

class _AnimatedLogoWrapperState extends State<AnimatedLogoWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: const Icon(
          Icons.hub,
          color: Colors.white,
          size: 20,
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

  void _showBlogDetail(BuildContext context, BlogPost post) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "BlogDetail",
    barrierColor: Colors.black.withOpacity(0.85),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) {
      // 1. Wrap in Material to remove the yellow underlines
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(post.imageUrl, 
                      height: 220, width: double.infinity, fit: BoxFit.cover),
                    
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(post.category, 
                                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 10)),
                              ),
                              const Spacer(),
                              const Icon(Icons.bookmark_border, color: Colors.white54),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.title, 
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 24, 
                              fontWeight: FontWeight.bold,
                              // No need for decoration: none here anymore because of Material wrapper
                            )
                          ),
                          const SizedBox(height: 12),
                          Text("${post.date} • 2026 Edition", 
                            style: const TextStyle(color: Colors.white30, fontSize: 12)),
                          const SizedBox(height: 20),
                          const Text(
                            "CLINICAL SUMMARY",
                            style: TextStyle(color: Colors.blueAccent, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "This clinical review explores the intersection of AI-assisted diagnostics and robotic precision. Recent 2026 data indicates a significant reduction in post-operative inflammation.",
                            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                          ),
                          const SizedBox(height: 32),
                          
                          // Improved Close Button
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text("DISMISS", 
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12 * anim1.value, sigmaY: 12 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: child,
          ),
        ),
      );
    },
  );
}
  // Ensure this points to your file

  // ... (Inside your _OrthoHomeScreenState build method)

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroCarousel(),
          const SizedBox(height: 24),
          _buildSectionTitle("Ortho-Hub Powered by RUSA-UNOM"),

          const ClinicalPulseTicker(),

          // --- NEW BLOG SECTION START ---
          _buildSectionTitle("Clinical Insights"),
          _buildBlogScroll(), // This fetches from blog_data.dart
          const SizedBox(height: 32),

          // --- NEW BLOG SECTION END ---
          

          _buildSectionTitle("AI Research Engine"),
          const AIEngineSection(),
          const SizedBox(height: 32),

          _buildSectionTitle("Latest Implants"),
          const ImplantPromotionCard(),
          const SizedBox(height: 32),

          _buildSectionTitle("Resource Library"),
          const ResourceScroll(),
          _buildSectionTitle("Expert Deep Dives"),
const AnimatedTextFeed(), // The new unique section

_buildSectionTitle("Orthopaedic Categories"),
          const OrthoBentoGrid(),
          const SizedBox(height: 32),
          const InnovationFooter(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Horizontal Blog Scroller
  Widget _buildBlogScroll() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: blogPosts.length, // From blog_data.dart
        itemBuilder: (context, index) {
          final post = blogPosts[index];
          return _buildBlogCard(post);
        },
      ),
    );
  }

  Widget _buildBlogCard(BlogPost post) {
    return GestureDetector(
      onTap: () => _showBlogDetail(context, post), // Trigger the detail view
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: NetworkImage(post.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      post.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${post.date} • ${post.readTime}",
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
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

class ClinicalPulseTicker extends StatefulWidget {
  const ClinicalPulseTicker({super.key});

  @override
  State<ClinicalPulseTicker> createState() => _ClinicalPulseTickerState();
}

class _ClinicalPulseTickerState extends State<ClinicalPulseTicker> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Delay start slightly to ensure layout is ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        
        // If we reach the end, jump back to start for infinite loop effect
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + 1.0); // Adjust speed here
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Clinical data points for the ticker
    final List<String> pulses = [
      "FDA CLEARANCE: BIOTITAN SCREW SYSTEM V2.1",
      "TRENDING: 12% RISE IN ROBOTIC-ASSISTED THA",
      "RESEARCH: NEW POLYMER COATINGS REDUCE INFECTION",
      "GLOBAL: ORTHO-CON 2026 STARTS IN 48 HOURS",
      "ALERT: SUPPLY CHAIN UPDATE ON COBALT-CHROME",
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.05),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // Multiply items to ensure we have enough to scroll seamlessly
        itemBuilder: (context, index) {
          final text = pulses[index % pulses.length];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.blueAccent, size: 14),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 20),
                Text("•", style: TextStyle(color: Colors.white.withOpacity(0.2))),
              ],
            ),
          );
        },
      ),
    );
  }
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


// Ensure this matches your file name where AIToolPage is defined
// import 'ai_tool_page.dart'; 

class AIEngineSection extends StatelessWidget {
  const AIEngineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190, 
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          // 1. NER ENGINE CARD
          _aiCard(
            context,
            "NER Engine", // Tool Name
            "Named Entity Recognition for identifying medical terms, anatomy, and surgical instruments.",
            Icons.psychology_outlined,
            const Color(0xFF818CF8), // Indigo Theme
          ),
          // 2. SUMMARIZER CARD
          _aiCard(
            context,
            "Summarizer", // Tool Name
            "Generates concise clinical summaries from lengthy orthopedic research papers and reports.",
            Icons.summarize_outlined,
            const Color(0xFFFB923C), // Orange Theme
          ),
          // 3. PREDICTOR CARD
          _aiCard(
            context,
            "Predictor", // Tool Name
            "Advanced forecasting models for fracture healing times and surgical outcome probabilities.",
            Icons.query_stats_rounded,
            const Color(0xFF34D399), // Green Theme
          ),
        ],
      ),
    );
  }

  Widget _aiCard(
    BuildContext context, 
    String title, 
    String desc, 
    IconData icon, 
    Color accentColor,
  ) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 20, bottom: 15),
      child: GestureDetector(
        onTapDown: (_) => HapticFeedback.lightImpact(),
        onTap: () => _showAIModelDetails(context, title, desc, accentColor, icon),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accentColor.withOpacity(0.12), Colors.transparent],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accentColor, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    "CORE ENGINE",
                    style: TextStyle(
                      color: accentColor.withOpacity(0.6), 
                      fontSize: 8, 
                      letterSpacing: 2, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 18, 
                      fontWeight: FontWeight.w900, 
                      letterSpacing: 1
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAIModelDetails(
    BuildContext context, 
    String title, 
    String desc, 
    Color accent, 
    IconData icon
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF080B0D),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(color: accent.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4, 
                decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(10))
              )
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Icon(icon, color: accent, size: 28),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SYSTEM INITIALIZATION", style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              desc,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15, height: 1.6),
            ),
            const Spacer(),
            // --- REDIRECT LOGIC ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context); // Close BottomSheet
                  
                  // Navigating to your specific AIToolPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AIToolPage(
                        toolName: title, 
                        themeColors: [accent, accent.withOpacity(0.5)],
                      ),
                    ),
                  );
                },
                child: const Text(
                  "INITIALIZE ENGINE", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
        setState(() {
          _shouldShowMedia = true;
        });
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
      child: GestureDetector(
        // --- NAVIGATION TRIGGER ---
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrthoImplantsPage()),
          );
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // 1. Video Layer
                if (_shouldShowMedia &&
                    _controller != null &&
                    _controller!.value.isInitialized)
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

                // 2. Futuristic Overlay
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Badge
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          const Text("LIVE CATALOG", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        "Implant Repository",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Explore 24+ clinical hardware modules",
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      // "Explore" Button UI
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("OPEN PORTAL", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
                          ],
                        ),
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
 // Import your new data file

class AnimatedTextFeed extends StatelessWidget {
  const AnimatedTextFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // We use a Column since it's inside a SingleChildScrollView
      child: Column(
        children: List.generate(deepDivePosts.length, (index) {
          final data = deepDivePosts[index];
          // Each item gets a progressive delay (0ms, 200ms, 400ms...)
          return _buildAnimatedParagraph(data, index * 200);
        }),
      ),
    );
  }

  Widget _buildAnimatedParagraph(DeepDiveModel data, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000),
      curve: Interval(
        (delay / 2000).clamp(0, 0.5), // Creates the staggered entrance
        1.0,
        curve: Curves.easeOutQuart,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)), // Slides up from bottom
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withOpacity(0.03), // Subtle glass effect
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.15 * value),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Modern vertical accent line
                      Container(
                        width: 3,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        data.title.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.content,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      height: 1.7,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${data.author} • ${data.readTime}",
                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ),
                      const Spacer(),
                      // Animated "Read More" Arrow
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: Colors.blueAccent.withOpacity(value),
                        size: 18,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InnovationFooter extends StatelessWidget {
  const InnovationFooter({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          "ORTHOHUB powered By RUSA & UNOM v2.0.4 • 2026",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 10),
        ),
      ),
    );
  }
}



void showFuturisticDisclaimer(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false, // User MUST click Accept
    barrierLabel: "Disclaimer",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: const Color(0xFF0A0D10).withOpacity(0.9),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.gavel_rounded, color: Color(0xFF6366F1), size: 32),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "MEDICAL DISCLAIMER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "This RUSA 2.0 Ortho-Hub application is for educational and clinical research purposes only. It does not constitute medical advice or diagnosis. Always consult a certified specialist for surgical decisions.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Accept Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "I UNDERSTAND & ACCEPT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "DATA INTEGRITY VERIFIED",
                          style: TextStyle(color: Colors.white10, fontSize: 8, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}