import 'package:guide_wizard/models/sub_task/sub_task.dart';

class Task {
  int id;
  int step_id;
  int text;
  int description;
  String? image_1;
  String? image_2;
  List<SubTask> sub_tasks;
  int creator_id;
  String created_at;
  String updated_at;
  bool isDone;

  Task({
    required this.id,
    required this.step_id,
    required this.text,
    required this.description,
    required this.image_1,
    required this.image_2,
    required this.sub_tasks,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    this.isDone = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      step_id: json["step_id"],
      text: json["text"],
      description: json["description"],
      image_1: json["image_1"],
      image_2: json["image_2"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      sub_tasks: List<SubTask>.from(json["sub_tasks"].map((x) => SubTask.fromMap(x))),
      isDone: json["isDone"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "step_id": step_id,
    "text": text,
    "description": description,
    "image_1": image_1,
    "image_2": image_2,
    "sub_tasks": sub_tasks.map((sub_task) => sub_task.toMap()).toList(),
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
    "isDone": isDone,
  };

  bool get isTypeOfText => image_1 == null && image_2 == null;
  bool get isTypeOfImage => !isTypeOfText;
  int get subTaskCount => sub_tasks.length;

  void setDone(bool value) {
    isDone = value;
  }

  void toggleDone() {
    isDone = !isDone;
  }
}
