import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    50: Color(0xFFFFAE61),
    100: Color(0xFFF4A75F),
    200: Color(0xFF563A20),
  };

  static const Map<int, Color> red = const <int, Color>{
    50: Color.fromARGB(255, 187, 100, 94),
    100: Color.fromARGB(255, 169, 25, 12),
  };

  static const Map<int, Color> green = const <int, Color>{
    50: Color.fromARGB(255, 115, 213, 172),
    100: Color(0xFF31EC92),
  };

  static const Map<int, Color> blue = const <int, Color>{
    50: Color.fromARGB(255, 118, 178, 227),
    100: Color.fromRGBO(0, 81, 158, 1),
    200: const Color.fromARGB(255, 2, 25, 44)
  };

  static const Map<int, Color> grey = const <int, Color>{
    50: Color.fromARGB(255, 245, 244, 244),
    100: const Color.fromRGBO(224, 224, 224, 1),
    200: Color.fromARGB(255, 158, 158, 158),
    300: const Color.fromRGBO(217, 217, 217, 0.15),
  };

  static Color get orange50 => orange[50]!;
  static Color get orange100 => orange[100]!;
  static Color get red100 => red[100]!;
  static Color get green50 => green[50]!;
  static Color get green100 => green[100]!;
  static Color get grey50 => grey[50]!;
  static Color get grey100 => grey[100]!;
  static Color get grey200 => grey[200]!;
  static Color get grey300 => grey[300]!;
  static Color get blue50 => blue[50]!;
  static Color get blue100 => blue[100]!;
  static Color get blue200 => blue[200]!;
  static Color get white => Colors.white;
}
