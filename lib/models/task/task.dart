import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/title/title.dart';

class Task {
  int id;
  Title title;
  List<String>? image;
  List<SubTask> sub_tasks;
  String creator_id;
  String created_at;
  String updated_at;

  Task({
    required this.id,
    required this.title,
    this.image,
    required this.sub_tasks,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Task.fromMap(Map<String, dynamic> json) {
    // return Answer(
    //   id: json["id"],
    //   title: json ["title"],
    //   text: json["text"],
    //   image: Endpoints.domain +
    //       '/api/app/answers/img/${json["image"].toString().replaceAll(
    //           Endpoints.domain + '/api/app/answers/img/', '')}',
    //   color: json["color"],
    //   selected: (json["selected"] == null) ? false : json["selected"],
    //   updated_at: json["updated_at"],
    //   is_enabled: json["is_enabled"] == 1 ? true : false,
    //   disabled_text: json ["disabled_text"],
    // );
    return Task(
      id: json["id"],
      title: json["title"].cast<Title>(),
      image: json["image"],
      sub_tasks: json["sub_tasks"].cast<SubTask>(),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "sub_tasks": sub_tasks,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };

}