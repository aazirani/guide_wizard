import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/updated_at_times/updated_at_times.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'updated_at_times_store.g.dart';

class UpdatedAtTimesStore = _UpdatedAtTimesStore with _$UpdatedAtTimesStore;

abstract class _UpdatedAtTimesStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _UpdatedAtTimesStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<UpdatedAtTimes?> emptyUpdatedAtTimesResponse =
  ObservableFuture.value(null);
  static ObservableFuture<dynamic> emptyTruncateUpdatedAtTimesResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<UpdatedAtTimes?> fetchUpdatedAtTimesFuture =
  ObservableFuture<UpdatedAtTimes?>(emptyUpdatedAtTimesResponse);

  @observable
  ObservableFuture<dynamic> truncateQuestionsFuture =
  ObservableFuture<dynamic>(emptyTruncateUpdatedAtTimesResponse);

  @observable
  UpdatedAtTimes? updatedAtTimes;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchUpdatedAtTimesFuture.status == FutureStatus.pending;

  @computed
  bool get loadingTruncate => truncateQuestionsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future updateContentIfNeeded() async {
    await _repository.updateContentIfNeeded();
  }

  @action
  Future truncateContent() async {
    await _repository.truncateContent();
  }

  @action
  Future getUpdatedAtTimes() async {
    final future = _repository.getTheLastUpdatedAtTimes();
    fetchUpdatedAtTimesFuture = ObservableFuture(future);

    future.then((updatedAtTimes) {
      this.updatedAtTimes = updatedAtTimes;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  Future truncateTable() async {
    final future = _repository.truncateUpdatedAtTimes();
    truncateQuestionsFuture = ObservableFuture(future);

    future.catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  Future updateUpdatedAtTimes() async {
    final future = _repository.getTheLastUpdatedAtTimes();
    fetchUpdatedAtTimesFuture = ObservableFuture(future);

    future.then((updatedAtTimes) {
      this.updatedAtTimes = updatedAtTimes;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  Future truncateUpdatedAtTimes() async {
    await _repository.truncateUpdatedAtTimes();
  }
}
