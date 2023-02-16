import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/task/task_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'sub_task_store.g.dart';

class SubTaskStore = SubTaskStore with _$SubTaskStore;

abstract class _SubTaskStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _SubTaskStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
  static ObservableFuture<TaskList?> emptyTaskResponse =
  ObservableFuture.value(null);
  static ObservableFuture<dynamic> emptyTruncateTaskResponse =
  ObservableFuture.value(null);

  @observable
  ObservableFuture<TaskList?> fetchTasksFuture =
  ObservableFuture<TaskList?>(emptyTaskResponse);

  @observable
  ObservableFuture<dynamic> truncateQuestionsFuture =
  ObservableFuture<dynamic>(emptyTruncateTaskResponse);

  @observable
  List<SubTask>? subTasks;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTasksFuture.status == FutureStatus.pending;

  @computed
  bool get loadingTruncate => truncateQuestionsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getSubTasks(int task_id) async {
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);

    future.then((taskList) {
      taskList.tasks.forEach((task) {
        if(task.id == task_id){
          this.subTasks = task.subTasks;
        }
      });
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }
}
