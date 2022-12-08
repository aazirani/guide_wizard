import 'package:boilerplate/utils/enums/enum.dart';
import '../task/task.dart';

class Step {
  late String title;
  late StepStatus status;
  late double percentage;
  late int numTasks;
  late List<Task> tasks;
  Step(
      {required this.title,
      this.status = StepStatus.notStarted,
      required this.percentage,
      required this.numTasks,
      required this.tasks});

  void setStatus(StepStatus status) {
    this.status = status;
  }

  void setPercentage(double percentage) {
    this.percentage = percentage;
  }
}
