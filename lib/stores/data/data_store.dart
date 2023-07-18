import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/task/task_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:boilerplate/models/step/step.dart';
import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/question/question_list.dart';

// // Include generated file
part 'data_store.g.dart';

// This is the class used by rest of your codebase
class DataStore = _DataStore with _$DataStore;

abstract class _DataStore with Store {
  Repository _repository;
  _DataStore(Repository repo) : this._repository = repo;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  //steplist observables
  static ObservableFuture<StepList> emptyStepsResponse =
      ObservableFuture.value(StepList(steps: []));

  @observable
  ObservableFuture<StepList> fetchStepsFuture =
      ObservableFuture<StepList>(emptyStepsResponse);

  @observable
  StepList stepList = StepList(steps: []);

  @observable
  bool stepSuccess = false;

  @computed
  bool get stepLoading => fetchStepsFuture.status == FutureStatus.pending;

  //tasklist observables
  static ObservableFuture<TaskList?> emptyTaskResponse =
      ObservableFuture.value(null);

  static ObservableFuture<dynamic> emptyTruncateTaskResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<TaskList?> fetchTasksFuture =
      ObservableFuture<TaskList?>(emptyTaskResponse);

  @observable
  ObservableFuture<dynamic> truncateTasksFuture =
      ObservableFuture<dynamic>(emptyTruncateTaskResponse);

  @observable
  TaskList taskList = TaskList(tasks: []);

  @observable
  bool tasksSuccess = false;

  //questions observables:
  static ObservableFuture<QuestionList?> emptyQuestionResponse =
      ObservableFuture.value(null);
  static ObservableFuture<dynamic> emptyTruncateQuestionResponse =
      ObservableFuture.value(null);

  @observable
  ObservableFuture<QuestionList?> fetchQuestionsFuture =
      ObservableFuture<QuestionList?>(emptyQuestionResponse);

  @observable
  ObservableFuture<dynamic> truncateQuestionsFuture =
      ObservableFuture<dynamic>(emptyTruncateQuestionResponse);

  @observable
  QuestionList questionList = QuestionList(questions: []);

  @observable
  bool questionSuccess = false;
  //answers observables:
  @observable
  List<Answer> answers = [];

  @observable
  bool success = false;
  //tasks computed:
  @computed
  bool get tasksLoading => fetchTasksFuture.status == FutureStatus.pending;

  @computed
  bool get tasksLoadingTruncate =>
      truncateTasksFuture.status == FutureStatus.pending;

  //questions computed:
  @computed
  bool get questionLoading =>
      fetchQuestionsFuture.status == FutureStatus.pending;

  @computed
  bool get questionLoadingTruncate =>
      truncateQuestionsFuture.status == FutureStatus.pending;

// actions......................................................................
  @action
  Future getSteps() async {
    final future = _repository.getStep();
    fetchStepsFuture = ObservableFuture(future);
    await future.then((stepList) {
      this.stepList = stepList;
    });
  }

  @action
  Future stepDataSourceCount() => _repository.stepDatasourceCount();

  @action
  Future truncateSteps() async {
    await _repository.truncateStep();
  }

  //tasks actions: .............................................................
  @action
  Future getAllTasks() async {
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
  Future getTasks(int id) async {
    final future = _repository.getTasks();
    fetchTasksFuture = ObservableFuture(future);
    List<Task> relatedTasks = [];
    future.then((taskList) {
      taskList.tasks.forEach((task) {
        if (task.step_id == id) {
          relatedTasks.add(task);
        }
      });
      TaskList temp = TaskList(tasks: relatedTasks);
      this.taskList = temp;
    });
  }

  @action
  Task getTaskById(int taskId) {
    return taskList.tasks.firstWhere((task) => task.id == taskId);
  }

  @action
  Future updateTask(Task task) async {
    await _repository.updateTask(task);
  }

  @action
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

  @action
  Future truncateTasks() async {
    await _repository.truncateTask();
  }

  //questions actions: .........................................................
  @action
  Future getQuestions() async {
    final future = _repository.getQuestions();
    fetchQuestionsFuture = ObservableFuture(future);

    future.then((questionList) {
      this.questionList = questionList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });
    return future;
  }

  @action
  Future updateQuestion(Question question, Answer answer, bool value) async {
    questionList.questions
        .firstWhere((element) => element == question)
        .answers
        .firstWhere((element) => element == answer)
        .selected = value;
    await _repository.updateQuestion(question);
  }

  @action
  Question getQuestionById(int questionId) {
    return questionList.questions
        .firstWhere((question) => question.id == questionId);
  }

  @action
  Future truncateQuestionTable() async {
    final future = _repository.truncateQuestions();
    truncateQuestionsFuture = ObservableFuture(future);

    future.catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  @action
  Future updateQuestions() async {
    final future = _repository.getUpdatedQuestion();
    fetchQuestionsFuture = ObservableFuture(future);

    future.then((questionList) {
      this.questionList = questionList;
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

  @action
  Future truncateQuestions() async {
    await _repository.truncateQuestions();
  }

  // answers actions:
  get getAnswers => answers;

  @action
  Future<void> updateAnswers() async {
    try {
      final stepList = await _repository.getStep();

      answers = stepList.steps
          .expand((step) => step.tasks.expand((task) => task.questions.expand(
              (question) =>
                  question.answers.where((answer) => answer.selected))))
          .toList();
    } on DioError catch (error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    }
  }

  //.............................................................................
  String? getStepImage(int stepNum) {
    return this.stepList.steps[stepNum].image;
  }

  int getNumberOfSteps() {
    return this.stepList.steps.length;
  }

  int getNumberOfTaskListTasks() {
    return this.taskList.numTasks;
  }

  int getStepId(stepIndex) {
    return this.stepList.steps[stepIndex].id;
  }

  int getStepTitleId(stepIndex) {
    return this.stepList.steps[stepIndex].name;
  }

  int getTaskTitleId(stepIndex, taskIndex) {
    return this.stepList.steps[stepIndex].tasks[taskIndex].text;
  }

  int getTaskTitleIdByIndex(taskIndex) {
    return this.taskList.tasks[taskIndex].text;
  }

  int getTaskId(taskIndex) {
    return this.taskList.tasks[taskIndex].id;
  }

  Task getTaskByIndex(taskIndex) {
    return this.taskList.tasks[taskIndex];
  }

  getNumberOfTasksFromAStep(index) {
    return this.stepList.steps[index].numTasks;
  }

  int getNumberofDoneTasks(currentStepNo) {
    int numDoneTasks = taskList.tasks
        .where((task) =>
            task.step_id == stepList.steps[currentStepNo].id && task.isDone)
        .length;
  
    return numDoneTasks;
  }
  
  bool getTaskIsDoneStatus(taskIndex) {
    return this.taskList.tasks[taskIndex].isDone;
  }

  bool getTaskType(taskIndex) {
    return this.taskList.tasks[taskIndex].isTypeOfText;
  }
}
