import 'package:guide_wizard/data/repository.dart';
import 'package:guide_wizard/models/answer/answer.dart';
import 'package:guide_wizard/models/question/question.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/error/error_store.dart';
import 'package:mobx/mobx.dart';

// // Include generated file
part 'data_store.g.dart';

// This is the class used by rest of your codebase
class DataStore = _DataStore with _$DataStore;

abstract class _DataStore with Store {
  Repository _repository;

  _DataStore(Repository repo) : this._repository = repo;

  @observable
  bool dataLoad = false;

  @action
  void dataLoaded() {
    this.dataLoad = true;
  }

  @action
  void dataNotLoaded() {
    this.dataLoad = false;
  }

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  //steplist observables
  static ObservableFuture<List<AppStep>> emptyStepsResponse = ObservableFuture.value(List.empty());

  @observable
  ObservableFuture<List<AppStep>> fetchStepsFuture = ObservableFuture<List<AppStep>>(emptyStepsResponse);

  @observable
  List<AppStep> stepList = List.empty();

  @computed
  bool get stepSuccess => fetchStepsFuture.status == FutureStatus.fulfilled;

  @computed
  bool get stepLoading => fetchStepsFuture.status == FutureStatus.pending;

  //Actions......................................................................
  @action
  Future getStepsFromDb() async {
    final future = _repository.getStepsFromDb();
    fetchStepsFuture = ObservableFuture(future);
    await fetchStepsFuture.then((steps) {
      steps.sort((a, b) => a.order.compareTo(b.order));
      this.stepList = steps;
    });
  }

  @action
  Future getStepsFromApi() async {
    await _repository.getStepFromApiAndInsert();
    await getStepsFromDb();
  }

  @action
  List<AppStep> getAllSteps() {
    return this.stepList;
  }

  @action
  AppStep getStepById(int stepId) {
    return this.getAllSteps().firstWhere((step) => step.id == stepId);
  }

  @action
  bool isFirstStep(int stepId) {
    return this.getAllSteps().reduce((curr, next) => curr.order < next.order ? curr : next)
        .id == stepId;
  }

  @action
  int getIndexOfStep(int stepId){
    return this.getAllSteps().indexWhere((step) => step.id == stepId);
  }

  @action
  AppStep getStepByIndex(int index){
    return this.getAllSteps().elementAt(index);
  }

  @action
  Future stepDataSourceCount() => _repository.stepDatasourceCount();

  @action
  Future isDataSourceEmpty() async =>  (await _repository.stepDatasourceCount()) == 0;

  @action
  Future truncateSteps() async {
    await _repository.truncateStep();
  }

  //Tasks Actions: .............................................................
  @action
  List<Task> getAllTasks() {
    return this.getAllSteps().expand((step) => step.tasks).toList();
  }

  @action
 Task getTaskById(int id) {
    return getAllTasks().firstWhere((task) => task.id == id);
  }

  @action
  Future updateTask(Task task) async {
    AppStep step = this.getAllSteps().firstWhere((step) => step.id == task.step_id);
    int indexOfTask = step.tasks.indexWhere((t) => t.id == task.id);
    if (indexOfTask != -1) {
      step.tasks[indexOfTask] = task;
    }
    await _repository.updateStep(step);
  }

  //Questions Actions: .........................................................
  @action
  List<Question> getAllQuestions() {
    return this.getAllSteps().expand((step) => step.questions).toList();
  }

  @action
  Future updateQuestion(Question question) async {
    AppStep step = this.getAllSteps().firstWhere((step) => step.id == question.step_id);
    int indexOfQuestion = step.questions.indexWhere((q) => q.id == question.id);

    if (indexOfQuestion != -1) {
      step.questions[indexOfQuestion] = question;
    }
    await _repository.updateStep(step);
  }

  @action
  Question getQuestionById(int questionId) {
    return getAllQuestions().firstWhere((question) => question.id == questionId);
  }

  //Other: .....................................................................

  List<Task> getDoneTasks(int stepId) {
    return getAllTasks().where((task) => task.step_id == stepId && task.isDone).toList();
  }

  bool isAllTasksOfStepDone(int stepId){
    return this.getStepById(stepId).tasks.length == this.getDoneTasks(stepId);
  }

  List<Answer> getSelectedAnswers(){
    return getAllQuestions().expand((question) => question.answers.where((answer) => answer.isSelected)).toList();
  }

  bool stepIsDone(int stepId) {
    return (this.isAllTasksOfStepDone(this.getStepById(stepId).id)
        && this.getStepById(stepId).questions.isEmpty)
        || (this.getStepById(stepId).questions.expand((question) => question.answers.where((answer) => answer.isSelected)).length == this.getStepById(stepId).questions.length
            && this.getStepById(stepId).tasks.isEmpty);
  }

  bool stepIsPending(int stepId) {
    return !this.stepIsDone(stepId) &&
        ((this.getStepById(stepId).questions.expand((question) => question.answers.where((answer) => answer.isSelected)).isNotEmpty
    && this.getStepById(stepId).tasks.isEmpty)
        || this.getStepById(stepId).tasks.where((task) => task.isDone).isNotEmpty && this.getStepById(stepId).questions.isEmpty);
  }

  bool stepIsNotStarted(int stepId) {
    return this.getStepById(stepId).questions.expand((question) => question.answers.where((answer) => answer.isSelected)).isEmpty && this.getStepById(stepId).tasks.isEmpty
    || this.getStepById(stepId).tasks.where((task) => task.isDone).isEmpty && this.getStepById(stepId).questions.isEmpty;
  }

}
