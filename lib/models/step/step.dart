import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/title/title.dart';

class Step {
  int id;
  TechnicalName name;
  TechnicalName description;
  int order;
  String? image;
  List<Task> tasks;

  Step({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.image,
    required this.tasks
  });

  factory Step.fromMap(Map<String, dynamic> json) {
    return Step(
      id: json["id"],
      name: TechnicalName.fromMap(json["name"]),
      description: TechnicalName.fromMap(json["description"]),
      order: json["order"],
      image: json["image"],
      tasks: json["tasks"].map((answer) => Task.fromMap(answer)).toList().cast<Task>(),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name.toMap(),
    "description": description.toMap(),
    "order": order,
    "image": image,
    "tasks": tasks.map((task) => task.toMap()).toList(),
  };

}