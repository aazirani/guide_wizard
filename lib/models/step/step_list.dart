import 'package:guide_wizard/models/step/app_step.dart';
import 'package:mobx/mobx.dart';

class AppStepList {
  @observable
  final ObservableList<AppStep> steps;

  AppStepList({
    required this.steps,
  });

  @action
  factory AppStepList.fromJson(List<dynamic> json) {
    List<AppStep> steps;
    steps = ObservableList.of(json.map((step) => AppStepFactory().fromMap(step)).toList().cast<AppStep>());

    return AppStepList(
      steps: ObservableList.of(steps),
    );
  }

}
