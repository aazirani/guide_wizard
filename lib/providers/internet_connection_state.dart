import 'package:flutter/material.dart';

class InternetConnectionState extends ChangeNotifier{
  bool hasInternet = false;
  InternetConnectionState();

  Future<void> setHasInternet(bool newValue) async {
    hasInternet = newValue;
    notifyListeners();
  }
}