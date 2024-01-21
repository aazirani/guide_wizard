class SettingsConstants {
  SettingsConstants._();

  static const cacheImageDuration = const Duration(days: 14);
  static const errorSnackBarDuration = Duration(days: 1000); // 1000 means Infinity here
  static const updateRequiredSnackBarDuration = Duration(seconds: 7);
  static const internetCheckingPeriod = Duration(seconds: 7);
  static const updateRequestStop = Duration(minutes: 5);

  static const webMaxWidth = 600.0;
}
