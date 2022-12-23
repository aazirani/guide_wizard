import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/title/title.dart';

class Task {
  int id;
  TechnicalName text;
  TechnicalName description;
  String type;
  String? image1;
  String? image2;
  String? fa_icon;
  List<SubTask> sub_tasks;
  String creator_id;
  String created_at;
  String updated_at;
  List<Question> quesions;

  Task({
    required this.id,
    required this.text,
    required this.description,
    required this.type,
    required this.image1,
    required this.image2,
    required this.fa_icon,
    required this.sub_tasks,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.quesions,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      text: TechnicalName.fromMap(json["text"]),
      description: TechnicalName.fromMap(json["description"]),
      type: json["type"],
      image1: json["image1"],
      image2: json["image2"],
      fa_icon: json["fa_icon"],
      sub_tasks: List<SubTask>.from(
          json["sub_tasks"].map((x) => SubTask.fromMap(x))),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      quesions: List<Question>.from(
          json["questions"].map((x) => Question.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "text": text.toMap(),
    "description": description.toMap(),
    "type": type,
    "image1": image1,
    "image2": image2,
    "sub_tasks": sub_tasks.map((sub_task) => sub_task.toMap()).toList(),
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
    "quesions": quesions.map((question) => question.toMap()).toList(),
  };

}