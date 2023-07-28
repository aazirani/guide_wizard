class ScrollingOverflowTextConstants {
  ScrollingOverflowTextConstants._();

  static const double defaultHeight = 30;
  static const double defaultOverflowRatio = 0.7;

  static const Duration cacheImageDuration = const Duration(days: 14);
  static const bool showFadingOnlyWhenScrolling = false;
  static const Duration startAfter = Duration(seconds: 5);
  static const Duration pauseAfterRound = Duration(seconds: 3);
  static const double fadingEdgeEndFraction = 0.3;
  static const double blankSpace = 100;
  static const double velocity = 40;
}
