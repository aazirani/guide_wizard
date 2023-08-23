import 'package:flutter/material.dart';

class QuestionsWidgetState extends ChangeNotifier {
  int? activeIndex;
  QuestionsWidgetState({this.activeIndex});

  Future<void> setActiveIndex(int? index) async {
    activeIndex = activeIndex == index ? null : index;
    notifyListeners();
  }

  bool isWidgetExpanded(int? index){
    return activeIndex == index;
  }

  bool isLastQuestion({required int questionsCount}) {
    return activeIndex == questionsCount - 1;
  }
}