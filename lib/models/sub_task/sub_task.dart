import 'package:boilerplate/models/technical_name/technical_name.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';
import 'package:flutter/material.dart';

class SubTask {
  int id;
  // TODO: add task ID
  // int task_id;
  TechnicalName title;
  TechnicalName markdown;
  TechnicalName deadline;
  int order;
  int creator_id;
  String created_at;
  String updated_at;
  late GlobalKey<AppExpansionTileState> globalKey;
  bool expanded = false;
  
  SubTask({
    required this.id,
    // required this.task_id,
    required this.title,
    required this.markdown,
    required this.deadline,
    required this.order,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  }) {
    _buildGlobalKey();
  }

  factory SubTask.fromMap(Map<String, dynamic> json) {
    return SubTask(
      id: json["id"],
      // task_id: json["task_id"],
      title: TechnicalName.fromMap(json["title"]),
      markdown: TechnicalName.fromMap(json["markdown"]),
      deadline: TechnicalName.fromMap(json["deadline"]),
      order: json["order"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        // "task_id": task_id,
        "title": title.toMap(),
        "markdown": markdown.toMap(),
        "deadline": deadline.toMap(),
        "order": order,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  void _buildGlobalKey() {
    globalKey = GlobalKey<AppExpansionTileState>();
  }

  void rebuildGlobalKey() {
    _buildGlobalKey();
  }

  void setExpanded(bool value) {
    expanded = value;
  }

  void toggleExpanded() {
    expanded = !expanded;
  }
}
