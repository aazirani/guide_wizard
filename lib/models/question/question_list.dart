import 'package:guide_wizard/models/question/question.dart';
import 'package:mobx/mobx.dart';

class QuestionList {
  @observable
  ObservableList<Question> questions;

  QuestionList({
    required this.questions,
  });

  @computed
  int get length => questions.length;

  @action
  factory QuestionList.fromJson(List<dynamic> json) {
    List<Question> questions = json.map((question) => QuestionFactory().fromMap(question)).toList();
    return QuestionList(
      questions: ObservableList<Question>.of(questions),
    );
  }
}
