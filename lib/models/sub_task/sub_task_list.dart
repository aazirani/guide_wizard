import 'package:guide_wizard/models/sub_task/sub_task.dart';

class SubTaskList {
  List<SubTask> subTasks;
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

  set setSubTasks(List<SubTask> subTasks) {
    subTasks = subTasks; 
  }
}
