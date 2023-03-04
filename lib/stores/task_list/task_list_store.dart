import 'package:mobx/mobx.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/task/task_list.dart';

import '../../di/components/service_locator.dart';
import '../../models/task/task.dart';
import '../step/step_store.dart';

// // Include generated file
part 'task_list_store.g.dart';

// This is the class used by rest of your codebase
class TaskListStore = _TaskListStore with _$TaskListStore;

abstract class _TaskListStore with Store {
  Repository _repository;
  // StepStore _stepStore = StepStore();
  StepStore _stepStore = getIt<StepStore>();

  _TaskListStore(Repository repository) : this._repository = repository;

  static ObservableFuture<TaskList?> emptyTaskList =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<TaskList?> fetchTasksFuture =
      ObservableFuture<TaskList?>(emptyTaskList);

  @observable
  TaskList taskList = TaskList(tasks: []);

  @observable
  bool success = false;

  @computed
  bool get loading => fetchTasksFuture.status == FutureStatus.pending;

  @action
  Future getTaskList(int id) async {
    print(_stepStore.currentStep);
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);
    TaskList temp = TaskList(tasks: []);
    List<Task> relatedTasks = [];
    future.then((taskList) {
      taskList.tasks.forEach((task) {
        if (task.step_id == id) {
          relatedTasks.add(task);
        }
      });
      temp.setTasks = relatedTasks;
      this.taskList = temp;
    });
  }
}
