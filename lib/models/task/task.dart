import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/technical_name/technical_name.dart';

class Task {
  int id;
  int step_id;
  TechnicalName text;
  TechnicalName description;
  String? image1;
  String? image2;
  List<SubTask> sub_tasks;
  int creator_id;
  String created_at;
  String updated_at;
  List<Question> questions;
  bool isDone;

  Task({
    required this.id,
    required this.step_id,
    required this.text,
    required this.description,
    required this.image1,
    required this.image2,
    required this.sub_tasks,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.questions,
    this.isDone = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      step_id: json["step_id"],
      text: TechnicalName.fromMap(json["text"]),
      description: TechnicalName.fromMap(json["description"]),
      image1: json["image1"],
      image2: json["image2"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      questions: List<Question>.from(
          json["questions"].map((x) => Question.fromMap(x))),
      sub_tasks:
          List<SubTask>.from(json["sub_tasks"].map((x) => SubTask.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "step_id": step_id,
        "text": text.toMap(),
        "description": description.toMap(),
        "image1": image1,
        "image2": image2,
        "sub_tasks": sub_tasks.map((sub_task) => sub_task.toMap()).toList(),
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
        "questions": questions.map((question) => question.toMap()).toList(),
      };

  void setDone(bool value) {
    isDone = value;
  }

  void toggleDone() {
    isDone = !isDone;
  }

  int get subTaskCount {
    return sub_tasks.length;
  }

  get deadLine {
    if (sub_tasks.isEmpty == false) {
      for (var sb = 0; sb <= sub_tasks.length; sb++) {
        if (sub_tasks[sb].deadline.technical_name != "") {
          return true;
        }
      }
    }
    return null;
  }
}
