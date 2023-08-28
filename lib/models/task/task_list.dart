import 'package:guide_wizard/models/task/task.dart';
import 'package:mobx/mobx.dart';

class TaskList {
  @observable
  final ObservableList<Task> tasks;

  TaskList({required this.tasks});

  @action
  factory TaskList.fromJson(List<dynamic> json) {
    List<Task> tasks;

    tasks = json.map((task) => TaskFactory().fromMap(task)).toList();

    return TaskList(
      tasks: ObservableList<Task>.of(tasks),
    );
  }

  @computed
  int get numTasks => tasks.length;
}
