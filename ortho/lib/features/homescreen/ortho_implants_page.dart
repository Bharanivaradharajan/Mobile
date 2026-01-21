import 'package:flutter/material.dart';
import 'dart:ui';
import 'implants_data.dart';

class OrthoImplantsPage extends StatelessWidget {
  const OrthoImplantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: const Color(0xFF030507),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BIO-ARCHITECTURES", 
                    style: TextStyle(color: accentColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4)),
                  const SizedBox(height: 8),
                  const Text("The Science of\nOrthopaedic Implants", 
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
                  const SizedBox(height: 16),
                  Text(ImplantsData.definition, 
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 15, height: 1.6)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildBlogDetailCard(ImplantsData.typeDetails[index], accentColor),
              childCount: ImplantsData.typeDetails.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
              child: Row(
                children: [
                  const Text("NEURAL CATALOG (24)", 
                    style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(width: 12),
                  Expanded(child: Container(height: 1, color: Colors.white10)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => InteractiveImplantCard(item: ImplantsData.catalog24[index]),
                childCount: 24,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
      ),
    );
  }

  Widget _buildBlogDetailCard(ImplantTypeDetail data, Color accent) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: Image.asset(
              data.imagePath,
              height: 180, 
              width: double.infinity, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180, color: Colors.white10, 
                child: const Icon(Icons.image_not_supported, color: Colors.white24)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(data.icon, color: accent, size: 20),
                    const SizedBox(width: 10),
                    Text(data.category, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(data.description, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.5)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: data.subTypes.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(t, style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.bold)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveImplantCard extends StatefulWidget {
  final ImplantModel item;
  const InteractiveImplantCard({super.key, required this.item});

  @override
  State<InteractiveImplantCard> createState() => _InteractiveImplantCardState();
}

class _InteractiveImplantCardState extends State<InteractiveImplantCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.item.accentColor;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: _isPressed ? (Matrix4.identity()..scale(0.95)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isPressed ? color : color.withOpacity(0.12),
            width: _isPressed ? 2 : 1,
          ),
          boxShadow: [
            if (_isPressed)
              BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, spreadRadius: -2)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.item.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, e, s) => Container(
                          color: Colors.white.withOpacity(0.03),
                          child: const Icon(Icons.inventory_2_outlined, color: Colors.white10),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              _isPressed ? color.withOpacity(0.4) : Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.id, 
                    style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(widget.item.name, 
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, height: 1.2),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 32,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isPressed ? color : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: color.withOpacity(0.5)),
                    ),
                    child: Center(
                      child: Text("ANALYZE", 
                        style: TextStyle(
                          color: _isPressed ? Colors.white : color, 
                          fontSize: 9, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1
                        )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}