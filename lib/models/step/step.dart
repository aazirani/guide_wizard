import 'package:boilerplate/utils/enums/enum.dart';

class Step {
  late String title;
  late StepStatus status;
  late double percentage;
  late int numTasks;
  // late List<subTasks> subTasks;
  Step(
      {required this.title,
      this.status = StepStatus.notStarted,
      required this.percentage,
      required this.numTasks});

  void setStatus(StepStatus status) {
    this.status = status;
  }

  void setPercentage(double percentage) {
    this.percentage = percentage;
  }
}
