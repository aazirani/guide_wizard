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

  Future<String> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language).then((_) => language);
  }

  // Loading dialog:---------------------------------------------------------------------
  Future<bool> get isDataLoaded async {
    return _sharedPreference.getBool(Preferences.is_data_loaded) ?? false;
  }

  // current step:---------------------------------------------------
  bool get answerWasUpdated {
    return _sharedPreference.getBool(Preferences.answer_was_updated) ?? false;
  }

  Future<void> setAnswerWasUpdated(bool mustUpdate) {
    return _sharedPreference.setBool(Preferences.answer_was_updated, mustUpdate);
  }
}
