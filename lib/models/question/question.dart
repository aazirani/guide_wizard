import 'package:boilerplate/models/answer/answer.dart';

class Question {
  //Server Values
  int id;
  List<dynamic> title; //TODO
  List<dynamic> sub_title; //TODO
  String type;
  int axis_count;
  bool is_multiple_choice;
  List<dynamic> info_url; //TODO
  List<dynamic> info_description; //TODO
  int answer_required;
  bool answers_selected_by_default;
  int step_id;
  int creator_id;
  String created_at;
  String updated_at;
  List<dynamic> step; //TODO
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
    required this.step_id,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.step,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> json) {
    //for Userfrosting
    // return Question(
    //   id: json["id"],
    //   title: json["title"],
    //   sub_title: json["sub_title"],
    //   updated_at: json["updated_at"],
    //   answers: json["answers"].map((answer) => Answer.fromMap(answer)).toList().cast<Answer>(),
    //   type: json["type"],
    //   is_multiple_choice: json["is_multiple_choice"] == 1  ? true : false,
    //   axis_count: json["axis_count"],
    //   info_url: json["info_url"],
    //   info_description: json["info_description"],
    //   show_on_startup: json["show_on_startup"] == 1  ? true : false,
    //   answers_selected_by_default: json["answers_selected_by_default"] == 1  ? true : false,
    // );
    return Question(
        id: json["id"],
        title: json["title"],
        sub_title: json["sub_title"],
        type: json["type"],
        axis_count: json["axis_count"],
        is_multiple_choice: json["is_multiple_choice"] == 1  ? true : false,
        info_url: json["info_url"],
        info_description: json["info_description"],
        answer_required: json["answer_required"],
        answers_selected_by_default: json["answers_selected_by_default"] == 1  ? true : false,
        step_id: json["step_id"],
        creator_id: json["creator_id"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
        step: json["step"],
        answers: json["answers"].map((answer) => Answer.fromMap(answer)).toList().cast<Answer>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "sub_title": sub_title,
      "type": type,
      "axis_count": axis_count,
      "is_multiple_choice": is_multiple_choice,
      "info_url": info_url,
      "info_description": info_description,
      "answer_required": answer_required,
      "answers_selected_by_default": answers_selected_by_default,
      "step_id": step_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "step": step,
      "answers": answers,
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

  //TODO
  // void deselectAllAnswers() {
  //   for (Answer answer in answers) {
  //     answer.selected = false;
  //   }
  // }
  //TODO
  // void selectAnswers(List<Answer> answersToBeSelected) {
  //   deselectAllAnswers();
  //   for (Answer answer in answersToBeSelected) {
  //     answer.selected = true;
  //   }
  // }
}
