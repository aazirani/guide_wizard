import 'package:boilerplate/utils/enums/enum.dart';

class Step {
  late StepTitle title;
  late StepStatus status;

  Step({required this.title, this.status = StepStatus.notStarted});

  void setStatus(StepStatus status) {
    this.status = status;
  }
}
