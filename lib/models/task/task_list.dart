import 'package:boilerplate/models/task/task.dart';

class TaskList {
  List<Task> tasks;
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
    for (Task task in tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  set setTasks(List<Task> tasks) {
    this.tasks = tasks;
  }

  int noOfDoneTasks() {
    var no = 0; 
    for (var task = 0; task < numTasks; task++) {
      if (tasks[task].isDone == true) {
        no ++; 
      }
    }
    return no; 
  }
}
