import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- DATABASE MODEL ---
class DoctorModel {
  final String name, specialty, city, hospital, imageUrl, websiteUrl;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.city,
    required this.hospital,
    required this.imageUrl,
    required this.websiteUrl,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'] ?? "Unknown Doctor",
      specialty: json['specialty'] ?? "Specialist",
      city: json['city'] ?? "Chennai",
      hospital: json['hospital'] ?? "General Hospital",
      // Check your Django Serializer: if the field is 'image', change 'image_url' to 'image'
      imageUrl: json['image_url'] ?? "https://via.placeholder.com/150",
      websiteUrl: json['website_url'] ?? "https://google.com",
    );
  }
}

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String selectedCity = "All";
  late Future<List<DoctorModel>> _doctorFuture;
  List<String> availableCities = ["All"];

  final List<Color> accentColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF10B981), // Emerald
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFEC4899), // Pink
    const Color(0xFF8B5CF6), // Violet
  ];

  @override
  void initState() {
    super.initState();
    _doctorFuture = _fetchDoctors();
  }

  Future<List<DoctorModel>> _fetchDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access');

    // Make sure this IP matches your running Django server
    const String url = "http://192.168.2.103:8000/api/doctor/";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<DoctorModel> doctors =
            data.map((item) => DoctorModel.fromJson(item)).toList();

        // Dynamically update the city filter list
        Set<String> cities = {"All"};
        for (var doc in doctors) {
          if (doc.city.isNotEmpty) cities.add(doc.city);
        }

        setState(() {
          availableCities = cities.toList();
        });

        return doctors;
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized: Please login again.");
      } else {
        throw Exception("Failed to load doctors: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      rethrow;
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showDoctorDetails(DoctorModel doc, Color accentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildDetailModal(doc, accentColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      body: FutureBuilder<List<DoctorModel>>(
        future: _doctorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white24, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _doctorFuture = _fetchDoctors();
                    }),
                    child: const Text("Retry Connection"),
                  ),
                ],
              ),
            );
          }

          final allDoctors = snapshot.data ?? [];
          final filteredDoctors = selectedCity == "All"
              ? allDoctors
              : allDoctors.where((doc) => doc.city == selectedCity).toList();

          return Stack(
            children: [
              // Ambient background glow
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6366F1).withOpacity(0.05),
                  ),
                ),
              ),

              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 50)),
                  // Header Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "FACULTY NETWORK",
                            style: TextStyle(
                              color: Color(0xFF6366F1),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Clinical Surgeons",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildPillFilter(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // List of Doctors
                  filteredDoctors.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(50.0),
                              child: Text("No doctors found in this city.",
                                  style: TextStyle(color: Colors.white38)),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final accentColor = accentColors[
                                    index % accentColors.length];
                                return _buildFuturisticCard(
                                  filteredDoctors[index],
                                  accentColor,
                                );
                              },
                              childCount: filteredDoctors.length,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPillFilter() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableCities.length,
        itemBuilder: (context, index) {
          final city = availableCities[index];
          bool isSelected = selectedCity == city;
          return GestureDetector(
            onTap: () => setState(() => selectedCity = city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : Colors.white.withOpacity(0.07),
                ),
              ),
              child: Text(
                city,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFuturisticCard(DoctorModel doc, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () => _showDoctorDetails(doc, accentColor),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.12),
                accentColor.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: accentColor.withOpacity(0.1),
                backgroundImage: NetworkImage(doc.imageUrl),
                onBackgroundImageError: (_, __) => const Icon(Icons.person),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.specialty.toUpperCase(),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: Colors.white24),
                        const SizedBox(width: 4),
                        Text(doc.city,
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white10, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailModal(DoctorModel doc, Color accentColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
      decoration: BoxDecoration(
        color: const Color(0xFF07090C),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10))),
          const SizedBox(height: 30),
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(doc.imageUrl)),
          const SizedBox(height: 20),
          Text(doc.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(doc.specialty,
              style: TextStyle(color: accentColor, fontSize: 16)),
          const Divider(height: 40, color: Colors.white10),
          _modalInfoBlock(Icons.apartment, "Hospital", doc.hospital, accentColor),
          const SizedBox(height: 15),
          _modalInfoBlock(Icons.location_city, "Location", doc.city, accentColor),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () => _launchURL(doc.websiteUrl),
              child: const Text("VIEW PROFILE",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _modalInfoBlock(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        )
      ],
    );
  }
}