import 'package:mobx/mobx.dart';

// // Include generated file
part 'step_store.g.dart';

// This is the class used by rest of your codebase
class StepStore = _StepStore with _$StepStore;

abstract class _StepStore with Store {
  @observable
  int currentStep = 1;

  @action
  dynamic increment(int stepIndex) {
    currentStep = stepIndex;
  }
}
