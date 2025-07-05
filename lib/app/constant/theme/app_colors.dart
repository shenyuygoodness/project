import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient greenGradient = const LinearGradient(colors: [
    Color(0xFF429690),
    Color(0xFF2A7C76),
  ]);
  static Color primary = const Color(0xFF0F1A24);
  static Color secondary  = const Color(0xFF21364A);
  static Color blue = const Color(0xFF0D80F2);
  static Color grey = const Color(0xFF666666);
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);
  static Color tertiary  = const Color(0xFF8FADCC);


  static  List<Color> gradientColors = [
    AppColors.primary,
    AppColors.secondary,
  ];
}