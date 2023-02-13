import 'package:mobx/mobx.dart';
import 'package:boilerplate/models/step/step_list.dart';

import 'package:boilerplate/data/repository.dart';

import '../../models/task/task_list.dart';
import '../../utils/dio/dio_error_util.dart';

// // Include generated file
part 'task_list_store.g.dart';

// This is the class used by rest of your codebase
class TaskListStore = _TaskListStore with _$TaskListStore;

abstract class _TaskListStore with Store {
  Repository _repository;

  _TaskListStore(Repository repository) : this._repository = repository;

  static ObservableFuture<int> emptyTaskList = ObservableFuture.value(0);

  @observable
  ObservableFuture<int> fetchTasksFuture = ObservableFuture<int>(emptyTaskList);

  @observable
  TaskList taskList = TaskList(tasks: []);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTasksFuture.status == FutureStatus.pending;

  @action
  Future getProducts() async {
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);

    future.then((taskList) {
      this.taskList = taskList;
    });
  }
}
