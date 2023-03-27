import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/task/task_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'tasks_store.g.dart';

class TasksStore = _TasksStore with _$TasksStore;

abstract class _TasksStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _TasksStore(Repository repository) : this._repository = repository;

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
  TaskList? taskList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTasksFuture.status == FutureStatus.pending;

  @computed
  bool get loadingTruncate => truncateQuestionsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
  @action
  Future getTasks() async {
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);
    future.then((taskList) {
      this.taskList = taskList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Task getTaskById(int taskId) {
    return taskList!.tasks.firstWhere((task) => task.id == taskId);
  }

  Future truncateTable() async {
    final future = _repository.truncateTask();
    truncateQuestionsFuture = ObservableFuture(future);

    future.catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  @action
  bool isTaskTypeOfImage(Task task) {
    return task.isTypeOfImage;
  }

  @action
  bool isTaskTypeOfImageById(int taskId) {
    return isTaskTypeOfImage(getTaskById(taskId));
  }

  Future updateTasks() async {
    final future = _repository.getUpdatedTask();
    fetchTasksFuture = ObservableFuture(future);

    future.then((taskList) {
      this.taskList = taskList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  Future truncateTasks() async {
   await _repository.truncateTask();
  }
}
