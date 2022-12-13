import 'package:boilerplate/models/question/question.dart';

class QuestionList {
  final List<Question> questions;

  QuestionList({
    required this.questions,
  });

  factory QuestionList.fromJson(List<dynamic> json) {
    List<Question> questions = json.map((question) => Question.fromMap(question)).toList();

    return QuestionList(
      questions: questions,
    );
  }
}