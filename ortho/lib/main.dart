import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/homescreen/blog_data.dart';
import 'features/homescreen/auth_screen.dart'; // Make sure this path is correct

void main() {
  runApp(const OrthopedicApp());
}

class OrthopedicApp extends StatelessWidget {
  const OrthopedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030708),
        primaryColor: Colors.blueAccent,
      ),
      // Set the starting point
      home: const CarouselOnboarding(), 
    );
  }
}