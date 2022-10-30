import 'package:boilerplate/models/question/question.dart';

class ImageQuestion implements Question{
  String title, description;
  List<Map<String, dynamic>> options;
  bool multiChoice, isAnswered = false;
  late int columns;
  double? height, width;
  ImageQuestion({
    required this.title,
    required this.description,
    required this.options,
    required this.multiChoice,
    this.columns = 2,
    this.height,
    this.width,
  });

  void answer(){
    isAnswered=true;
  }
}
