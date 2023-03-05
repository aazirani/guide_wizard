import 'package:mobx/mobx.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/task/task_list.dart';

// // Include generated file
part 'task_list_store.g.dart';

// This is the class used by rest of your codebase
class TaskListStore = _TaskListStore with _$TaskListStore;

abstract class _TaskListStore with Store {
  Repository _repository;

  _TaskListStore(Repository repository) : this._repository = repository;

  static ObservableFuture<TaskList?> emptyTaskList = ObservableFuture.value(null);

  @observable
  ObservableFuture<TaskList?> fetchTasksFuture = ObservableFuture<TaskList?>(emptyTaskList);

  @observable
  TaskList? taskList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTasksFuture.status == FutureStatus.pending;

  @action
  Future getTasks() async {
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);

    future.then((taskList) {
      this.taskList = taskList;
    });
  }
}
