import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/stores/form/form_store.dart';
import 'package:mobx/mobx.dart';

part 'app_settings_store.g.dart';

class AppSettingsStore = _AppSettingsStore with _$AppSettingsStore;

abstract class _AppSettingsStore with Store {

  final Repository _repository;

  final FormErrorStore formErrorStore = FormErrorStore();

  final ErrorStore errorStore = ErrorStore();

  // current step number from 0 to steps_count-1
  @observable
  late int currentStepNumber = 0;
  // steps count (usually 4)
  @observable
  late int stepsCount = 0;

  // constructor:---------------------------------------------------------------
  _AppSettingsStore(Repository repository) : this._repository = repository {
    // setting up disposers
    _setupDisposers();

    currentStepNumber = _repository.currentStepNumber ?? 0;
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => success, (_) => success = false, delay: 200),
    ];
  }

  // empty responses:-----------------------------------------------------------
  static ObservableFuture<bool> emptyLoginResponse = ObservableFuture.value(false);

  // store variables:-----------------------------------------------------------
  @observable
  bool success = false;

  @observable
  ObservableFuture<bool> loginFuture = emptyLoginResponse;

  @computed
  bool get isLoading => loginFuture.status == FutureStatus.pending;

  // step number methods:-------------------------------------------------------------------
  @action
  Future setStepNumber(int stepNumber) async {
    _repository.setCurrentStep(stepNumber);
    currentStepNumber = stepNumber;
  }

  @action
  Future setStepsCount(int newStepsCount) async {
    _repository.setStepsCount(newStepsCount);
    stepsCount = newStepsCount;
  }

  @action
  Future incrementStepNumber() async {
    setStepNumber(currentStepNumber + 1);
  }

  // must update methods:-----------------------------------------------------------
  @action
  Future getMustUpdate() async {
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
