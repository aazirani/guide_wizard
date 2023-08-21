import 'package:guide_wizard/data/repository.dart';
import 'package:mobx/mobx.dart';

part 'app_settings_store.g.dart';

class AppSettingsStore = _AppSettingsStore with _$AppSettingsStore;

abstract class _AppSettingsStore with Store {
  final Repository _repository;

  // current step number from 0 to steps_count-1
  @observable
  int currentStepId = 0;

  // constructor:---------------------------------------------------------------
  _AppSettingsStore(Repository repository) : this._repository = repository {
  }

  // observables
  static ObservableFuture<int?> emptyCurrentStepIdResponse = ObservableFuture.value(0);

  @observable
  ObservableFuture<int?> fetchCurrentStepIdFuture = ObservableFuture<int?>(emptyCurrentStepIdResponse);

  static ObservableFuture<bool?> emptyAnswerWasUpdatedResponse = ObservableFuture.value(false);

  @observable
  ObservableFuture<bool?> fetchAnswerWasUpdatedFuture = ObservableFuture<bool?>(emptyAnswerWasUpdatedResponse);

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  // store variables:-----------------------------------------------------------
  @computed
  bool get currentStepIdSuccess => fetchCurrentStepIdFuture.status == FutureStatus.fulfilled;

  @computed
  bool get currentStepIdLoading => fetchCurrentStepIdFuture.status == FutureStatus.pending;


  // step number methods:-------------------------------------------------------------------
  @action
  Future setCurrentStepId(int stepId) async {
    fetchCurrentStepIdFuture = ObservableFuture(_repository.setCurrentStepId(stepId));
    await fetchCurrentStepIdFuture.then((steps) async {
      currentStepId = stepId;
    });
  }

  // must update methods:-----------------------------------------------------------
  @action
  bool? getAnswerWasUpdated() {
    return _repository.getAnswerWasUpdated;
  }

  @action
  Future setAnswerWasUpdated(bool answersWasUpdated) async {
    return _repository.setAnswerWasUpdated(answersWasUpdated);
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
