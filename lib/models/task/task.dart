import 'package:boilerplate/utils/enums/enum.dart';

class Task {
  //TODO: add list of sub-task
  late String title;
  late TaskStatus status;
  DateTime? deadline;

  Task({
    required this.title,
    this.status = TaskStatus.notDone,
    this.deadline,
  });

  void setStatus(TaskStatus status) {
    this.status = status;
  }
}
