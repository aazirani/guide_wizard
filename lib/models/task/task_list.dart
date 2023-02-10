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

  Task? getTask(int id) {
    for(Task task in tasks){
      if(task.id == id){
        return task;
      }
    }
    return null;
  }

  set setTasks(List<Task> tasks) {
    tasks = tasks;
  }
}
