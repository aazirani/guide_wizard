import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/title/title.dart';
import 'package:boilerplate/models/question/question.dart';

class Task {
  int id;
  Title text;
  Title description;
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
    required this.sub_tasks,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.quesions,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    //   image: Endpoints.domain +
    //       '/api/app/answers/img/${json["image"].toString().replaceAll(
    //           Endpoints.domain + '/api/app/answers/img/', '')}',
    return Task(
      id: json["id"],
      text: json["text"].cast<Title>(),
      description: json["description"].cast<Title>(),
      type: json["type"],
      image1: json["image1"].cast<String>(),
      image2: json["image2"].cast<String>(),
      sub_tasks: json["sub_tasks"].cast<SubTask>(),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      quesions: json["question"].cast<Question>(),
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "text": text,
    "image1": image1,
    "image2": image2,
    "sub_tasks": sub_tasks,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
    "question": quesions,
  };

}