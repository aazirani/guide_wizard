import 'package:guide_wizard/models/answer/answer.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'question.g.dart';

// This is the class used by rest of your codebase
class Question = _Question with _$Question;

abstract class _Question with Store {
  @observable
  int id;

  @observable
  int title;

  @observable
  int sub_title;

  @observable
  String type;

  @observable
  int axis_count;

  @observable
  bool is_multiple_choice;

  @observable
  int info_url;

  @observable
  int info_description;

  @observable
  int step_id;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  @observable
  ObservableList<Answer> answers;

  _Question({
    required this.id,
    required this.title,
    required this.sub_title,
    required this.type,
    required this.axis_count,
    required this.is_multiple_choice,
    required this.info_url,
    required this.info_description,
    required this.step_id,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.answers,
  });

  @computed
  List<Answer> get getAnswers => answers.toList();

  @action
  void setAnswerValue(Answer answer, bool value) {
    answers.firstWhere((element) => element == answer).selected = value;
  }

  @computed
  bool get isImageQuestion => type == "IMAGE";

  @action
  void deselectAllAnswers() {
    for (Answer answer in answers) {
      answer.selected = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "sub_title": sub_title,
      "type": type,
      "axis_count": axis_count,
      "is_multiple_choice": is_multiple_choice ? 1 : 0,
      "info_url": info_url,
      "info_description": info_description,
      "step_id": step_id,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
    };
  }
}

class QuestionFactory {
  Question fromMap(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      title: json["title"],
      sub_title: json["sub_title"],
      type: json["type"],
      axis_count: json["axis_count"],
      is_multiple_choice: (json["is_multiple_choice"] == 1) ? true : false,
      info_url: json["info_url"],
      info_description: json["info_description"],
      step_id: json["step_id"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      answers: ObservableList<Answer>.of(json["answers"]
          .map((x) => AnswerFactory().fromMap(x))
          .toList()
          .cast<Answer>()),
    );
  }
}
