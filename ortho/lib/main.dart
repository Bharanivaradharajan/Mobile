import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_screen.dart';

void main() {
  runApp(const OrthopedicApp());
}

class OrthopedicApp extends StatelessWidget {
  const OrthopedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CarouselOnboarding(),
    );
  }
}
