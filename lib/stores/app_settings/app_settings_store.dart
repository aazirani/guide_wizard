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

  static ObservableFuture<bool?> emptyAnswerWasUpdatedResponse = ObservableFuture.value(false);

  @observable
  ObservableFuture<bool?> fetchAnswerWasUpdatedFuture = ObservableFuture<bool?>(emptyAnswerWasUpdatedResponse);

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  // step number methods:-------------------------------------------------------------------
  @action
  void setCurrentStepId(int stepId) {
    currentStepId = stepId;
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
