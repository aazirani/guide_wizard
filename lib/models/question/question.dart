import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/step/step.dart';
import 'package:boilerplate/models/title/title.dart';

class Question {
  //Server Values
  int id;
  Title title;
  Title sub_title;
  String type;
  int axis_count;
  bool is_multiple_choice;
  Title info_url;
  Title info_description;
  int answer_required;
  bool answers_selected_by_default;
  int creator_id;
  String created_at;
  String updated_at;
  Step step;
  List<Answer> answers;

  Question({
    required this.id,
    required this.title,
    required this.sub_title,
    required this.type,
    required this.axis_count,
    required this.is_multiple_choice,
    required this.info_url,
    required this.info_description,
    required this.answer_required,
    required this.answers_selected_by_default,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.step,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      title: Title.fromMap(json["title"]),
      sub_title: Title.fromMap(json["sub_title"]),
      type: json["type"],
      axis_count: json["axis_count"],
      is_multiple_choice: json["is_multiple_choice"] == 1 ? true : false,
      info_url: Title.fromMap(json["info_url"]),
      info_description: Title.fromMap(json["info_description"]),
      answer_required: json["answer_required"],
      answers_selected_by_default: json["answers_selected_by_default"] == 1 ? true : false,
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      step: Step.fromMap(json["step"]),
      answers: List<Answer>.from(
          json["answers"].map((x) => Answer.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title.toMap(),
      "sub_title": sub_title.toMap(),
      "type": type,
      "axis_count": axis_count,
      "is_multiple_choice": is_multiple_choice ? 1 : 0,
      "info_url": info_url.toMap(),
      "info_description": info_description.toMap(),
      "answer_required": answer_required,
      "answers_selected_by_default": answers_selected_by_default ? 1 : 0,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "step": step,
      "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
    };
  }

  Answer? getAnswer(int id) {
    for (Answer answer in answers) {
      if (answer.id == id) {
        return answer;
      }
    }
    return null;
  }

  void deselectAllAnswers() {
    for (Answer answer in answers) {
      answer.selected = false;
    }
  }

  void selectAnswers(List<Answer> answersToBeSelected) {
    deselectAllAnswers();
    for (Answer answer in answersToBeSelected) {
      answer.selected = true;
    }
  }
}
