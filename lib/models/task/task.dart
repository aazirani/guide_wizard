import 'package:guide_wizard/models/sub_task/sub_task.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'task.g.dart';

// This is the class used by rest of your codebase
class Task = _Task with _$Task;

abstract class _Task with Store {
  @observable
  int id;

  @observable
  int step_id;

  @observable
  int text;

  @observable
  int description;

  @observable
  String? image_1;

  @observable
  String? image_2;

  @observable
  ObservableList<SubTask> sub_tasks;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  @observable
  bool isDone = false;

  _Task({
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

  Map<String, dynamic> toMap() => {
    "id": id,
    "step_id": step_id,
    "text": text,
    "description": description,
    "image_1": image_1,
    "image_2": image_2,
    "sub_tasks": ObservableList.of(sub_tasks.map((sub_task) => sub_task.toMap())),
    "creator_id": creator_id,
    "created_at": created_at,
    "updated_at": updated_at,
    "isDone": isDone,
  };

  @computed
  bool get isTypeOfText => image_1 == null && image_2 == null;

  @computed
  bool get isTypeOfImage => !isTypeOfText;

  @computed
  int get subTaskCount => sub_tasks.length;

  @computed
  List<SubTask> get subTasks => sub_tasks;

  @action
  void setDone(bool value) {
    isDone = value;
  }

  @action
  void toggleDone() {
    isDone = !isDone;
  }
}

class TaskFactory {
  Task fromMap(Map<String, dynamic> json) {
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
      sub_tasks: ObservableList<SubTask>.of(json["sub_tasks"].map((x) => SubTaskFactory().fromMap(x)).toList().cast<SubTask>()),
      isDone: json["isDone"] ?? false,
    );
  }
}
