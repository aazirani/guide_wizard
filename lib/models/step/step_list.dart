import 'package:boilerplate/models/step/step.dart' as s;

class StepList {
  final List<s.Step> steps;

  StepList({
    required this.steps,
  });

  factory StepList.fromJson(List<dynamic> json) {
    List<s.Step> steps;
    steps = json.map((step) => s.Step.fromMap(step)).toList();

    return StepList(
      steps: steps,
    );
  }
}
