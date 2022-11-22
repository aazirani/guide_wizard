import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    50: const Color(0xFFFCF2E7),
    100: const Color(0xFFF8DEC3),
    200: const Color(0xFFF3C89C),
    300: const Color(0xFFEEB274),
    400: const Color(0xFFEAA256),
    500: const Color(0xFFE69138),
    600: const Color(0xFFE38932),
    700: const Color(0xFFDF7E2B),
    800: const Color(0xFFDB7424),
    900: const Color(0xFFD56217)
  };
  static const Map<int, Color> green = const <int, Color>{
    //Done and pending slider color
    50: const Color.fromARGB(218, 206, 240, 229),
    //progress bar and timeline indicator
    100: Color.fromARGB(255, 47, 205, 144),
  };

  static const Map<int, Color> greys = const <int, Color>{
    //white
    50: Color.fromARGB(255, 255, 255, 255),
    //notStartedSlider
    100: const Color.fromARGB(255, 243, 241, 241),
    //notStartedSlider border
    200: const Color.fromARGB(255, 177, 182, 186),

  };

  static const Color main_color = const Color.fromRGBO(0, 81, 158, 1);
  static const Color grey = const Color.fromRGBO(231, 231, 231, 1);
  static const Color button_background_color = const Color.fromRGBO(217, 217, 217, 0.15);
  static const Color bright_foreground_color = Colors.white;
  static const Color dotted_line_color = Colors.green;
  // static const Color white= const Colors.white.withOpacity(0.5);
}
