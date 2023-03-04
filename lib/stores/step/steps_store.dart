import 'package:boilerplate/models/step/step.dart';
import 'package:mobx/mobx.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/data/repository.dart';

// // Include generated file
part 'steps_store.g.dart';

// This is the class used by rest of your codebase
class StepsStore = _StepsStore with _$StepsStore;

abstract class _StepsStore with Store {

  Repository _repository;
  _StepsStore(Repository repo) : this._repository = repo; 

  static ObservableFuture<StepList?> emptyStepsResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<StepList?> fetchStepsFuture =
      ObservableFuture<StepList?>(emptyStepsResponse);

  @observable
  StepList stepList = StepList(steps: []);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchStepsFuture.status == FutureStatus.pending;

  @action
  Future getSteps() async {
    final future = _repository.getStep();
    fetchStepsFuture = ObservableFuture(future);
    future.then((stepList) {
      this.stepList = stepList;
    });
  }

  @action
  Future truncateSteps() async {
    await _repository.truncateTask();
  }
}
