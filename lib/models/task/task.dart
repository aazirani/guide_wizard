import 'package:boilerplate/utils/enums/enum.dart';

class Task {
  late String title;
  late StepStatus status;
  // late List<subTasks> subTasks;
  DateTime deadline = new DateTime(2022, 11, 4);
  // late List<subTasks> subTasks;
  Task(
      {required this.title,
      this.status = StepStatus.notStarted,});

  void setStatus(StepStatus status) {
    this.status = status;
  }

  // void setPercentage(double percentage) {
  //   this.percentage = percentage;
  // }
}
