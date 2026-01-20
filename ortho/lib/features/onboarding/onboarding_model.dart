import 'package:flutter/material.dart';

class OrthoCard {
  final String title;
  final String number;
  final String description;
  final Color color;
  final String image; // 👈 NEW

  OrthoCard({
    required this.title,
    required this.number,
    required this.description,
    required this.color,
    required this.image,
  });
}
