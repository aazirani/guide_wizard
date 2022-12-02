import 'package:boilerplate/models/title/title.dart';

class SubTask {
  int id;
  int task_id;
  Title title;
  String markdown;
  String creator_id;
  String created_at;
  String updated_at;

  SubTask({
    required this.id,
    required this.task_id,
    required this.title,
    required this.markdown,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory SubTask.fromMap(Map<String, dynamic> json) {
    return SubTask(
      id: json["id"],
      task_id: json["task_id"],
      title: Title.fromMap(json["title"]),
      markdown: json["markdown"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "task_id": task_id,
    "title": title,
    "markdown": markdown,
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
  };

}