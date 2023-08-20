import 'package:guide_wizard/data/repository.dart';
import 'package:mobx/mobx.dart';

part 'app_settings_store.g.dart';

class AppSettingsStore = _AppSettingsStore with _$AppSettingsStore;

abstract class _AppSettingsStore with Store {
  final Repository _repository;

  // current step number from 0 to steps_count-1
  @observable
  int currentStepId;

  // constructor:---------------------------------------------------------------
  _AppSettingsStore(Repository repository, {this.currentStepId = 1}) : this._repository = repository {
    // setting up disposers
    _setupDisposers();
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  bool success = false;

  // step number methods:-------------------------------------------------------------------
  @action
  Future setCurrentStepId(int stepId) async {
    currentStepId = stepId;
    await _repository.setCurrentStepId(stepId);
  }

  // must update methods:-----------------------------------------------------------
  @action
  Future<bool?> getMustUpdate() async {
    return _repository.getMustUpdate;
  }

  @action
  Future setMustUpdate(bool mustUpdate) async {
    _repository.setMustUpdate(mustUpdate);
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }
}
