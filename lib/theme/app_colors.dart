import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const primary = Color(0xFFCB9F00);
  static const secondary = Color(0xFF228B22);
  static const secondaryRed = Color(0xFF8B3535);
  static const accent = Color(0xFF6A0DAD);
  static const text = Color(0xFF333333);
  static const cardBorder = Color(0xFFA9A9A9);
  static const cardBackground = Color(0xFFFFFFFF);
  static const iconRed = Color(0xFFC62828);
  static const iconGrey = Color(0xFF616161);

  static const gradient = LinearGradient(
    colors: [accent, Color(0xFF620011)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}