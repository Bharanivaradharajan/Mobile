import 'package:flutter/material.dart';
import 'package:ortho/features/homescreen/auth_screen.dart';
import 'features/onboarding/onboarding_screen.dart'; 
// IMPORTANT: Ensure the path below matches your project structure
import 'features/homescreen/auth_screen.dart'; 

void main() {
  runApp(const OrthopedicApp());
}

class OrthopedicApp extends StatelessWidget {
  const OrthopedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orthopedic Portal',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF030708),
        primaryColor: Colors.blueAccent,
        fontFamily: 'Inter', // Optional: adds a cleaner look
      ),
      
      // 1. Set the initial route (The Onboarding Screen)
      initialRoute: '/',
      
      // 2. Define the route map
      routes: {
        '/': (context) => const CarouselOnboarding(),
        '/login': (context) => const AuthScreen(),
      },

      // Fallback for safety: If a route is missing, it goes back home
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const CarouselOnboarding());
      },
    );
  }
}