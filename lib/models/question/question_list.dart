import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/question/question.dart';

class QuestionList {
  List<Question> questions;

  QuestionList({
    required this.questions,
  });

  int get length {
    return questions.length;
  }

  Question elementAt(int index) {
    return questions.elementAt(index);
  }

  factory QuestionList.fromJson(List<dynamic> json) {
    List<Question> questions = json.map((question) => Question.fromMap(question)).toList();

    return QuestionList(
      questions: questions,
    );
  }

  set setQuestions(List<Question> questions) {
    questions = questions;
  }

  Future setAnswerValue(Question question, Answer answer, bool value) async{
    questions.firstWhere((element) => element == question).setAnswerValue(answer, value);
  }
}
