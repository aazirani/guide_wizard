import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/technical_name/technical_name.dart';

class Question {
  //Server Values
  int id;
  int title;
  int sub_title;
  String type;
  int axis_count;
  bool is_multiple_choice;
  int info_url;
  int info_description;
  int answer_required;
  bool answers_selected_by_default;
  int task_id;
  int creator_id;
  String created_at;
  String updated_at;
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
    required this.task_id,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.answers,
  });


  bool get answersHasTitle {
    if(answers.length != 0) {
      return answers.elementAt(0).hasTitle;
    }
    return false;
  }

  String get getTitle {
    return title.string;
  }

  String get getSubTitle {
    return sub_title.string;
  }

  List<Answer> getAnswers() {
    return answers;
  }

  void setAnswerValue(Answer answer, bool value){
    answers.firstWhere((element) => element==answer).selected = value;
  }

  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      id: json["id"],
      title: TechnicalName.fromMap(json["title"]),
      sub_title: TechnicalName.fromMap(json["sub_title"]),
      type: json["type"],
      axis_count: json["axis_count"],
      is_multiple_choice: (json["is_multiple_choice"] == 1) ? true : false,
      info_url: TechnicalName.fromMap(json["info_url"]),
      info_description: TechnicalName.fromMap(json["info_description"]),
      answer_required: json["answer_required"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
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
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
    };
  }

  bool get isImageQuestion{
    return type == "IMAGE";
  }
  Answer? getAnswerByID(int id) {
    for (Answer answer in answers) {
      if (answer.id == id) {
        return answer;
      }
    }
    return null;
  }

  Answer getAnswerByIndex(int index) {
    return answers.elementAt(index);
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
