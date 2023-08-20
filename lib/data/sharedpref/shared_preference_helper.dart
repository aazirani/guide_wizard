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
  int? get currentStepId {
    return _sharedPreference.getInt(Preferences.current_step_id);
  }

  Future<void> setCurrentStepId(int new_current_step_id) {
    return _sharedPreference.setInt(
        Preferences.current_step_id, new_current_step_id);
  }

  // current step:---------------------------------------------------
  bool? get mustUpdate {
    return _sharedPreference.getBool(Preferences.must_update);
  }

  Future<void> setMustUpdate(bool mustUpdate) {
    return _sharedPreference.setBool(Preferences.must_update, mustUpdate);
  }
}
