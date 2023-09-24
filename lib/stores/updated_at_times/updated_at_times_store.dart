import 'package:guide_wizard/data/repository.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';
import 'package:guide_wizard/stores/error/error_store.dart';
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

  @observable
  ObservableFuture<UpdatedAtTimes?> fetchUpdatedAtTimesFuture =
  ObservableFuture<UpdatedAtTimes?>(emptyUpdatedAtTimesResponse);

  @computed
  bool get updatedAtTimesLoading => fetchUpdatedAtTimesFuture.status == FutureStatus.pending;

  @computed
  bool get updatedAtTimesSuccess => fetchUpdatedAtTimesFuture.status == FutureStatus.fulfilled;

  // actions:-------------------------------------------------------------------
  @action
  Future<UpdatedAtTimes> getUpdatedAtTimesFromDb() async {
    try {
      fetchUpdatedAtTimesFuture = ObservableFuture(_repository.getUpdatedAtTimesFromDB());
      UpdatedAtTimes? updatedAtTimes = await fetchUpdatedAtTimesFuture;
      return updatedAtTimes ?? UpdatedAtTimes(
          last_updated_at_content: DateTime(1).toString(),
          last_updated_at_technical_names: DateTime(1).toString(),
          last_apps_request_time: DateTime.now().toString()
      );
    } catch (e) {
      return UpdatedAtTimes(
          last_updated_at_content: DateTime(1).toString(),
          last_updated_at_technical_names: DateTime(1).toString(),
          last_apps_request_time: DateTime.now().toString()
      );
    }
  }

  @action
  Future<UpdatedAtTimes> getUpdatedAtTimesFromApi() async {
    try {
      fetchUpdatedAtTimesFuture = ObservableFuture(_repository.getUpdatedAtTimesFromApiAndInsert());
      UpdatedAtTimes? updatedAtTimes = await fetchUpdatedAtTimesFuture;
      return updatedAtTimes ?? UpdatedAtTimes(
          last_updated_at_content: DateTime(1).toString(),
          last_updated_at_technical_names: DateTime(1).toString(),
          last_apps_request_time: DateTime(1).toString()
      );
    } catch (e) {
      return UpdatedAtTimes(
          last_updated_at_content: DateTime(1).toString(),
          last_updated_at_technical_names: DateTime(1).toString(),
          last_apps_request_time: DateTime(1).toString()
      );
    }
  }

}
