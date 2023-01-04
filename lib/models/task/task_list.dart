import 'package:boilerplate/models/task/task.dart';

class TaskList {
  final List<Task> tasks;
  TaskList({required this.tasks});

  factory TaskList.fromJson(List<dynamic> json) {
    List<Task> tasks;

    tasks = json.map((task) => Task.fromMap(task)).toList();

    return TaskList(
      tasks: tasks,
    );
  }

  int get numTasks {
    return tasks.length;
  }
}
