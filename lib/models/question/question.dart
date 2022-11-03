abstract class Question {
  late String title, description;
  late List<Map<String, dynamic>> options;
  late bool multiChoice, isAnswered = false;
}