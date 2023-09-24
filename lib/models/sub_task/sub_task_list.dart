import 'package:guide_wizard/models/sub_task/sub_task.dart';
import 'package:mobx/mobx.dart';

class SubTaskList {
  @observable
  ObservableList<SubTask> subTasks;

  SubTaskList({required this.subTasks});

  factory SubTaskList.fromJson(List<dynamic> json) {
    List<SubTask> subTasks;

    subTasks = json.map((subTask) => SubTaskFactory().fromMap(subTask)).toList();

    return SubTaskList(
      subTasks: ObservableList.of(subTasks),
    );
  }

  @computed
  int get numSubTasks => subTasks.length;
}
