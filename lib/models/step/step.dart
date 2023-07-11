import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/technical_name/technical_name.dart';

class Step {
  int id;
  int name;
  int description;
  int order;
  String? image;
  String creator_id;
  String created_at;
  String updated_at;
  List<Task> tasks;

  Step(
      {required this.id,
      required this.name,
      required this.description,
      required this.order,
      required this.image,
      required this.creator_id,
      required this.created_at,
      required this.updated_at,
      required this.tasks});

  factory Step.fromMap(Map<String, dynamic> json) {
    return Step(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      order: json["order"],
      image: json["image"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      tasks:
          json["tasks"].map((task) => Task.fromMap(task)).toList().cast<Task>(),
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
        "tasks": tasks.map((task) => task.toMap()).toList(),
      };

  int get numTasks {
    return tasks.length;
  }
}
