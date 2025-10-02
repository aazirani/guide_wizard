import 'package:mobx/mobx.dart';

// Include generated file
part 'sub_task.g.dart';

// This is the class used by rest of your codebase
class SubTask = _SubTask with _$SubTask;

abstract class _SubTask with Store {
  @observable
  int id;

  @observable
  int task_id;

  @observable
  int title;

  @observable
  int markdown;

  @observable
  int deadline;

  @observable
  int order;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  @observable
  bool expanded = false;
  
  _SubTask({
    required this.id,
    required this.task_id,
    required this.title,
    required this.markdown,
    required this.deadline,
    required this.order,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "task_id": task_id,
        "title": title,
        "markdown": markdown,
        "deadline": deadline,
        "order": order,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  @action
  void setExpanded(bool value) {
    expanded = value;
  }

  @action
  void toggleExpanded() {
    expanded = !expanded;
  }
}

class SubTaskFactory {
  SubTask fromMap(Map<String, dynamic> json) {
    return SubTask(
      id: json["id"] ?? 0,
      task_id: json["task_id"] ?? 0,
      title: json["title"] ?? 0,
      markdown: json["markdown"] ?? 0,
      deadline: json["deadline"] ?? 0,
      order: json["order"] ?? 0,
      creator_id: json["creator_id"] ?? 0,
      created_at: json["created_at"] ?? "",
      updated_at: json["updated_at"] ?? "",
    );
  }
}
