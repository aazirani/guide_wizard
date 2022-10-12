import 'package:boilerplate/models/question/question.dart';

class TextQuestion implements Question{
  String title, description;
  List<Map<String, dynamic>> options;
  bool multiChoice, isAnswered = false;

  TextQuestion({
    required this.title,
    required this.description,
    required this.options,
    required this.multiChoice,
  });

  void answer(){
    isAnswered=true;
  }
}
