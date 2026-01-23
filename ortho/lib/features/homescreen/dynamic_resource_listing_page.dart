import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DynamicResourceListing extends StatefulWidget {
  final String category;
  final Color themeColor;

  const DynamicResourceListing({super.key, required this.category, required this.themeColor});

  @override
  State<DynamicResourceListing> createState() => _DynamicResourceListingState();
}

class _DynamicResourceListingState extends State<DynamicResourceListing> {
  final TextEditingController _searchController = TextEditingController();
  final String _baseUrl = "http://192.168.2.103:8000/api/resources/";
  late Future<List<dynamic>> _resourceFuture;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _resourceFuture = _fetchData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // --- DATA FETCHING ---
  Future<List<dynamic>> _fetchData({String query = ""}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    if (token == null || token.isEmpty) {
      throw Exception("AUTH_REQUIRED");
    }

    String typeFilter = "";
    if (widget.category.contains("Digital Library")) {
      typeFilter = "BOOK";
    } else if (widget.category.contains("PubMed")) {
      typeFilter = "PUBMED";
    } else if (widget.category.contains("Research")) {
      typeFilter = "RESEARCH";
    }

    final String fullUrl = "$_baseUrl?type=$typeFilter&search=$query";
    
    try {
      final response = await http.get(
        Uri.parse(fullUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 10)); // Added timeout

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("AUTH_REQUIRED");
      } else {
        throw Exception("SERVER_ERROR");
      }
    } catch (e) {
      if (e.toString().contains("AUTH_REQUIRED")) rethrow;
      debugPrint("API Error: $e");
      // If logged in but getting data errors, we throw a specific error
      throw Exception("DATA_ERROR"); 
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _resourceFuture = _fetchData(query: _searchController.text);
    });
  }

  void _openLink(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint("Could not launch $url");
      }
    } catch (e) {
      debugPrint("Url Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.themeColor.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 10),
              _buildSearchBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: widget.themeColor,
                  backgroundColor: const Color(0xFF0D1117),
                  child: FutureBuilder<List<dynamic>>(
                    future: _resourceFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: widget.themeColor, strokeWidth: 2));
                      }
                      
                      if (snapshot.hasError) {
                        return _buildErrorState(snapshot.error.toString());
                      }
                      
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return _buildEmptyState();
                      }

                      final resources = snapshot.data!;
                      return widget.category == "Digital Library"
                          ? _buildBookGrid(resources)
                          : _buildArticleList(resources);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.category.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 3),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) _debounce!.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              setState(() {
                _resourceFuture = _fetchData(query: value);
              });
            });
          },
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: "Search in ${widget.category}...",
            hintStyle: const TextStyle(color: Colors.white24),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search_rounded, color: widget.themeColor.withOpacity(0.5), size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }

  // --- BOOK GRID ---
  Widget _buildBookGrid(List<dynamic> items) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildBookItem(items[index], index),
    );
  }

  Widget _buildBookItem(dynamic item, int index) {
    // NULL GUARDS FOR BOOKS
    final String title = item['title']?.toString() ?? "Untitled";
    final String author = item['author']?.toString() ?? "Unknown Author";
    final String? buyUrl = item['buy_url']?.toString();
    final String? rawPath = item['thumbnail']?.toString();

    String finalImageUrl = rawPath != null && rawPath.isNotEmpty 
        ? (rawPath.startsWith('http') ? rawPath : "http://192.168.2.103:8000/${rawPath.startsWith('/') ? rawPath.substring(1) : rawPath}")
        : "https://via.placeholder.com/150x200";

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
      ),
      child: GestureDetector(
        onTap: () => _openLink(buyUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: widget.themeColor.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    finalImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white.withOpacity(0.05),
                      child: const Icon(Icons.book_outlined, color: Colors.white10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            Text(author, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // --- ARTICLE LIST ---
  Widget _buildArticleList(List<dynamic> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildArticleItem(items[index], index),
    );
  }

  Widget _buildArticleItem(dynamic item, int index) {
    // NULL GUARDS FOR ARTICLES
    final String title = item['title']?.toString() ?? "Untitled Document";
    final String edition = item['edition']?.toString() ?? "RESEARCH";
    final String description = item['description']?.toString() ?? "";
    final String? articleUrl = item['article_url']?.toString();

    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(30 * (1 - value), 0), child: child),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(edition.toUpperCase(), 
                style: TextStyle(color: widget.themeColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 10),
              Text(title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, height: 1.3)),
              
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, height: 1.4),
                ),
              ],
              
              const SizedBox(height: 16),
              _smallActionBtn("VIEW SOURCE", Icons.arrow_outward_rounded, articleUrl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallActionBtn(String label, IconData icon, String? url) {
    return GestureDetector(
      onTap: () => _openLink(url),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: widget.themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            Icon(icon, color: widget.themeColor, size: 12),
          ],
        ),
      ),
    );
  }

  // --- REFINED ERROR STATE ---
  Widget _buildErrorState(String error) {
    final bool isAuth = error.contains("AUTH_REQUIRED") || error.contains("401");

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAuth ? Icons.lock_outline_rounded : Icons.refresh_rounded, 
              color: widget.themeColor, 
              size: 40
            ),
            const SizedBox(height: 24),
            Text(
              isAuth ? "SECURE ACCESS" : "LOAD ERROR",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)
            ),
            const SizedBox(height: 12),
            Text(
              isAuth 
                ? "Please sign in to access the ${widget.category}." 
                : "Something went wrong while loading the data.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (isAuth) {
                    await Navigator.pushNamed(context, '/login'); 
                    _handleRefresh(); 
                  } else {
                    _handleRefresh();
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor, 
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                ),
                child: Text(
                  isAuth ? "GO TO LOGIN" : "RETRY", 
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bubble_chart_outlined, color: Colors.white.withOpacity(0.05), size: 80),
          const SizedBox(height: 16),
          Text("No ${widget.category} found", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 14)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: _handleRefresh,
            child: Text("REFRESH PAGE", style: TextStyle(color: widget.themeColor)),
          )
        ],
      ),
    );
  }
}