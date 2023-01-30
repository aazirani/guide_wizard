import 'package:boilerplate/models/sub_task/sub_task.dart';

class SubTaskList {
  final List<SubTask> subTasks;
  SubTaskList({required this.subTasks});

  factory SubTaskList.fromJson(List<dynamic> json) {
    List<SubTask> subTasks;

    subTasks = json.map((subTask) => SubTask.fromMap(subTask)).toList();

    return SubTaskList(
      subTasks: subTasks,
    );
  }

  int get numSubTasks {
    return subTasks.length;
  }
}
