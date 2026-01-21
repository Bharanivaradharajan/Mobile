import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicResourceListing extends StatefulWidget {
  final String category;
  final Color themeColor;

  const DynamicResourceListing({super.key, required this.category, required this.themeColor});

  @override
  State<DynamicResourceListing> createState() => _DynamicResourceListingState();
}

class _DynamicResourceListingState extends State<DynamicResourceListing> {
  final TextEditingController _searchController = TextEditingController();

  // Mock Launch Logic
  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.category.toUpperCase(), 
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search titles, authors, or DOI...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white24),
                ),
              ),
            ),
          ),

          Expanded(
            child: widget.category == "Digital Library" 
                ? _buildBookGrid() 
                : _buildArticleList(),
          ),
        ],
      ),
    );
  }

  // --- VIEW 1: BOOK GRID (For Digital Library) ---
  Widget _buildBookGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: 6, // Mock count
      itemBuilder: (context, index) => _buildBookItem(),
    );
  }

  Widget _buildBookItem() {
    return GestureDetector(
      onTap: () => _openLink("https://example.com/buy-book"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/150x200"), // Replace with database image
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(color: widget.themeColor.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Campbell's Operative Orthopaedics", 
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const Text("Hardcopy / E-Book", style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  // --- VIEW 2: ARTICLE LIST (For PubMed & Research) ---
  Widget _buildArticleList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 8,
      itemBuilder: (context, index) => _buildArticleItem(),
    );
  }

  Widget _buildArticleItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("PMID: 342155", style: TextStyle(color: widget.themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              const Icon(Icons.star_border, color: Colors.white24, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Advances in Bio-compatible Titanium Implants for Acetabular Reconstruction",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          const Text("Authors: Dr. Arumugam, et al. | 2025", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              _smallActionBtn("READ ABSTRACT", Icons.description_outlined),
              const SizedBox(width: 10),
              _smallActionBtn("VIEW FULL PDF", Icons.picture_as_pdf_outlined),
            ],
          )
        ],
      ),
    );
  }

  Widget _smallActionBtn(String label, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => _openLink("https://pubmed.ncbi.nlm.nih.gov/"),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: widget.themeColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: widget.themeColor, size: 14),
              const SizedBox(width: 5),
              Text(label, style: TextStyle(color: widget.themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}