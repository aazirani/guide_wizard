  import 'package:boilerplate/data/repository.dart';
  import 'package:boilerplate/stores/error/error_store.dart';
  import 'package:boilerplate/stores/form/form_store.dart';
  import 'package:mobx/mobx.dart';


  part 'current_step_store.g.dart';

  class CurrentStepStore = _CurrentStepStore with _$CurrentStepStore;

  abstract class _CurrentStepStore with Store {
    // repository instance
    final Repository _repository;

    // store for handling form errors
    final FormErrorStore formErrorStore = FormErrorStore();

    // store for handling error messages
    final ErrorStore errorStore = ErrorStore();

    // current step number from 0 to steps_count-1
    late int current_step_number;
    // steps count (usually 4)
    late int steps_count = 4;

    // constructor:---------------------------------------------------------------
    _CurrentStepStore(Repository repository) : this._repository = repository {
      // setting up disposers
      _setupDisposers();

      current_step_number = _repository.currentStepNumber ?? 0;
    }

    // disposers:-----------------------------------------------------------------
    late List<ReactionDisposer> _disposers;

    void _setupDisposers() {
      _disposers = [
        reaction((_) => success, (_) => success = false, delay: 200),
      ];
    }

    // empty responses:-----------------------------------------------------------
    static ObservableFuture<bool> emptyLoginResponse =
    ObservableFuture.value(false);

    // store variables:-----------------------------------------------------------
    @observable
    bool success = false;

    @observable
    ObservableFuture<bool> loginFuture = emptyLoginResponse;

    @computed
    bool get isLoading => loginFuture.status == FutureStatus.pending;

    // actions:-------------------------------------------------------------------
    @action
    Future setStepNumber(int step_number) async {
      _repository.setCurrentStep(step_number);
      current_step_number = step_number;
    }

    @action
    Future setStepsCount(int new_steps_count) async {
      _repository.setStepsCount(new_steps_count);
      steps_count = new_steps_count;
    }

    @action
    Future incrementStepNumber() async {
      setStepNumber(current_step_number + 1);
    }


    // general methods:-----------------------------------------------------------
    void dispose() {
      for (final d in _disposers) {
        d();
      }
    }
  }