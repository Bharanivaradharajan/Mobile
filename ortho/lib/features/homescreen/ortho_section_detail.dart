import 'package:flutter/material.dart';
import 'ortho_content_db.dart';
import 'ortho_data_model.dart';

class OrthoSectionDetail extends StatelessWidget {
  final String sectionTitle;

  const OrthoSectionDetail({super.key, required this.sectionTitle});

  void _showTopicDetails(BuildContext context, OrthoArticle article) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDetailPopup(context, article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<OrthoArticle> sectionContent = OrthoContentDB.allArticles
        .where((article) => article.section == sectionTitle)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: Stack(
        children: [
          // Dynamic Background Glow (Continuity from Onboarding)
          Positioned(
            top: -100,
            left: -50,
            child: _buildGlow(const Color(0xFF6366F1).withOpacity(0.08)),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildFuturisticAppBar(context),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              
              sectionContent.isEmpty
                  ? SliverFillRemaining(child: _buildEmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildAnimatedTopicTile(context, sectionContent[index]),
                          childCount: sectionContent.length,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        ],
      ),
    );
  }

  // --- GLASS-MORPHIC APP BAR ---
  Widget _buildFuturisticAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF030708),
      expandedHeight: 140,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RUSA 2.0 / RESOURCE",
              style: TextStyle(
                color: const Color(0xFF6366F1).withOpacity(0.8),
                fontSize: 8,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sectionTitle.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ANIMATED GLASS TILE ---
  Widget _buildAnimatedTopicTile(BuildContext context, OrthoArticle article) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            onTap: () => _showTopicDetails(context, article),
            child: AnimatedScale(
              scale: isPressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withOpacity(0.02),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    _buildCircularActionIcon(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- THE POP-UP CONTENT CARD ---
  Widget _buildDetailPopup(BuildContext context, OrthoArticle article) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: const Color(0xFF080B0C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(28, 50, 28, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildHandle()),
                const SizedBox(height: 30),
                _buildPopupHeader(article),
                const SizedBox(height: 30),
                if (article.imageUrl != null) _buildImageFrame(article.imageUrl!),
                const SizedBox(height: 40),
                _sectionLabel("OVERVIEW"),
                const SizedBox(height: 12),
                Text(
                  article.description,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, height: 1.7),
                ),
                const SizedBox(height: 40),
                _sectionLabel("KEY CLINICAL PARAMETERS"),
                const SizedBox(height: 20),
                ...article.points.map((p) => _buildPointRow(p)).toList(),
                const SizedBox(height: 50),
              ],
            ),
          ),
          _buildCloseButton(context),
        ],
      ),
    );
  }

  // --- REUSABLE STYLING ELEMENTS ---

  Widget _buildGlow(Color color) {
    return Container(
      width: 300, height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 150, spreadRadius: 50)],
      ),
    );
  }

  Widget _buildCircularActionIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
      ),
      child: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF6366F1), size: 12),
    );
  }

  Widget _buildPopupHeader(OrthoArticle article) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.section.toUpperCase(),
          style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 3),
        ),
        const SizedBox(height: 8),
        Text(
          article.title,
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1),
        ),
      ],
    );
  }

  Widget _buildImageFrame(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPointRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 6, width: 6,
            decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() => Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)));

  Widget _sectionLabel(String text) => Text(text, style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2));

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 20, right: 20,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
          child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("SYNCHRONIZING REPOSITORY...", 
        style: TextStyle(color: Colors.white12, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
    );
  }
}