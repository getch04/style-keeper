import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color darkGray = Color(0xFF3B3B3B); // #3B3B3B
  static const Color yellow = Color(0xFFE9B727); // #E9B727
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF
  static const Color black = Color(0xFF000000); // #000000

  // Material Color for Theme
  static MaterialColor primarySwatch = MaterialColor(
    darkGray.value,
    <int, Color>{
      50: darkGray.withOpacity(0.1),
      100: darkGray.withOpacity(0.2),
      200: darkGray.withOpacity(0.3),
      300: darkGray.withOpacity(0.4),
      400: darkGray.withOpacity(0.5),
      500: darkGray.withOpacity(0.6),
      600: darkGray.withOpacity(0.7),
      700: darkGray.withOpacity(0.8),
      800: darkGray.withOpacity(0.9),
      900: darkGray,
    },
  );
}
