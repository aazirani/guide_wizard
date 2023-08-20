import 'package:guide_wizard/models/question/question.dart';
import 'package:guide_wizard/models/task/task.dart';

class AppStep {
  int id;
  int name;
  int description;
  int order;
  String? image;
  int creator_id;
  String created_at;
  String updated_at;
  List<Question> questions;
  List<Task> tasks;

  AppStep(
      {required this.id,
      required this.name,
      required this.description,
      required this.order,
      required this.image,
      required this.creator_id,
      required this.created_at,
      required this.updated_at,
      required this.questions,
      required this.tasks});

  factory AppStep.fromMap(Map<String, dynamic> json) {
    return AppStep(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      order: json["order"],
      image: json["image"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      questions: List<Question>.from(json["questions"].map((x) => Question.fromMap(x))),
      tasks: json["tasks"].map((task) => Task.fromMap(task)).toList().cast<Task>(),
    );
  }

  Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
      "description": description,
      "order": order,
      "image": image,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "questions": questions.map((question) => question.toMap()).toList(),
      "tasks": tasks.map((task) => task.toMap()).toList(),
  };

}
