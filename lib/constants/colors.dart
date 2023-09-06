import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> orange = const <int, Color>{
    50: Color.fromRGBO(255, 174, 97, 1),
    100: Color.fromRGBO(244, 167, 95, 1),
    200: Color.fromRGBO(86, 58, 32, 1),
  };

  static const Map<int, Color> red = const <int, Color>{
    50: Color.fromARGB(255, 187, 100, 94),
    100: Color.fromARGB(255, 169, 25, 12),
    // 150: Color.fromARGB(255, 198, 117, 111),
    200: Color.fromARGB(255, 166, 36, 36),
    250: Color.fromARGB(255, 160, 6, 6),
  };

  static const Map<int, Color> green = const <int, Color>{
    50: Color.fromARGB(218, 206, 240, 229),
    100: Color.fromARGB(255, 115, 213, 172),
    200: Color.fromARGB(255, 124, 222, 194),
    300: Color(0xFF31EC92),
  };

  static const Map<int, Color> blue = const <int, Color>{
    50: Color.fromARGB(255, 97, 145, 218),
  };

  static const Map<int, Color> greys = const <int, Color>{
    50: Color.fromARGB(255, 245, 244, 244),
    100: const Color.fromARGB(255, 243, 241, 241),
    200: const Color.fromARGB(255, 177, 182, 186),
    300: Color.fromARGB(255, 158, 158, 158),
    400: Color.fromARGB(255, 247, 246, 246),
    500: Color.fromARGB(255, 224, 222, 222),
    600: Color.fromARGB(255, 246, 246, 246),
  };

  static const Map<int, Color> step_timeline_connector_gradient =
      const <int, Color>{
    50: main_color,
    100: const Color.fromARGB(159, 77, 172, 180),
    // 200: Color.fromARGB(255, 115, 213, 172),
    200: Color(0xFF31EC92),
  };

  static Map<int, Color> shimmerGradientGreys = <int, Color>{
    50: Colors.grey[300]!,
    100: Colors.grey[200]!,
    200: Colors.grey[300]!,
  };
  //home page
  static Color homeBodyColor = Color.fromARGB(255, 251, 251, 251);
  //step timeline
  static Color stepTimelinePendingColor = green[300]!;
  static Color stepTimelineNotStartedNodeColor = greys[300]!;
  static Color stepTimelineNotStartedConnectorColor = greys[300]!;
  static Color stepTimelineContainerColor = greys[50]!.withOpacity(0.99);
  static Color stepTimelineContainerShadowColor = greys[300]!;
  //step slider
  static Color stepSliderUnavailableColor = greys[100]!;
  static Color stepSliderUnavailableBorder = greys[200]!;
  static Color stepSliderContinueButton = white;
  //progress bar
  static Color progressBarBackgroundColor = white;
  static Color progressBarValueColor = green[300]!;
  //compressed timeline
  static Color timelineCompressedConnectorColor = green[300]!;
  static Color timelineCompressedContainerColor = greys[400]!;
  static Color timelineCompressedContainerShadowColor = greys[500]!;
  //diamond indicator
  static Color diamondBorderColor = green[300]!;
  static Color diamondColor = green[300]!;
  // tasklist
  static Color tasklistConnectorColor = green[300]!;
  // static Color contentColor = greys[600]!;
  static Color contentColor = Colors.white;
  static Color contentDoneBorderColor = green[300]!.withOpacity(0.2);
  static Color contentUnDoneBorderColor = red[50]!.withOpacity(0.2);
  static Color deadlineDoneBorderColor = green[100]!;
  static Color deadlineUnDoneBorderColor = orange[100]!;
  static Color deadlineUnDoneContainerColor = orange[50]!;
  static Color deadlineDoneContainerColor = bright_foreground_color;
  static Color deadlineTextDoneColor = green[100]!;
  static Color deadlineTextUnDoneColor = main_color;
  static Color taskDoneBorder = green[100]!;
  static Color taskUnDoneBorder = main_color;
  // questionpage
  static Color nextStepColor = green[100]!;

  static const Color title_color = Colors.white;
  static const Color main_color = const Color.fromRGBO(0, 81, 158, 1);
  static const Color text_color = const Color.fromARGB(255, 2, 25, 44);
  static const Color grey = const Color.fromRGBO(231, 231, 231, 1);
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color button_background_color =
      const Color.fromRGBO(217, 217, 217, 0.15);
  static const Color bright_foreground_color = Colors.white;
  static const Color blockquoteColor = Color.fromARGB(255, 118, 178, 227);
  // static const Color dotted_line_color = Colors.green;
  static Color dotted_line_color = green[300]!;
  // static const Color white= const Colors.white.withOpacity(0.5);
  static Color close_button_color = Colors.grey[800]!;
}
