import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.auth_token);
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.current_language);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language);
  }

  // Loading dialog:---------------------------------------------------------------------
  Future<bool> get isDataLoaded async {
    return _sharedPreference.getBool(Preferences.is_data_loaded) ?? false;
  }

  // current step:---------------------------------------------------
  int? get currentStepNumber {
    return _sharedPreference.getInt(Preferences.current_step_number);
  }

  Future<void> setCurrentStep(int new_current_step) {
    return _sharedPreference.setInt(
        Preferences.current_step_number, new_current_step);
  }

  int? get stepsCount {
    return _sharedPreference.getInt(Preferences.steps_count);
  }

  Future<void> setStepsCount(int new_steps_count) {
    return _sharedPreference.setInt(Preferences.steps_count, new_steps_count);
  }

  // progress value:------------------------------------------------
  List<double> getProgressValues(int stepCount) {
    List<String> stringValues =
        _sharedPreference.getStringList(Preferences.progress_values) ??
            List<String>.filled(stepCount, "0");

    return stringValues.map((value) => double.tryParse(value) ?? 0.0).toList();
  }

  Future<void> setProgressValue(List<double> values) async {
    await _sharedPreference.setStringList(Preferences.progress_values,
        values.map((value) => value.toString()).toList());
  }
}
