import 'package:guide_wizard/models/step/app_step.dart' as s;

class AppStepList {
  final List<s.AppStep> steps;

  AppStepList({
    required this.steps,
  });

  factory AppStepList.fromJson(List<dynamic> json) {
    List<s.AppStep> steps;
    steps = json.map((step) => s.AppStep.fromMap(step)).toList();

    return AppStepList(
      steps: steps,
    );
  }

  List<s.AppStep> get listStep {
    return steps;
  }

}
