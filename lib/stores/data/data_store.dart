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

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // observables
  static ObservableFuture<List<AppStep>> emptyStepsResponse = ObservableFuture.value(List.empty());

  @observable
  ObservableFuture<List<AppStep>> fetchStepsFuture = ObservableFuture<List<AppStep>>(emptyStepsResponse);

  @observable
  ObservableList<AppStep> stepList = ObservableList.of(List.empty());

  @observable
  bool _loadingDataFromDbOrServer = false;

  @computed
  bool get stepSuccess => fetchStepsFuture.status == FutureStatus.fulfilled;

  @computed
  bool get stepLoading => fetchStepsFuture.status == FutureStatus.pending;

  @computed
  bool get isLoading => _loadingDataFromDbOrServer;

  @computed
  List<AppStep> get getAllSteps => this.stepList;

  @computed
  bool get isEmpty => fetchStepsFuture.value == null ? true : fetchStepsFuture.value!.isEmpty;

  //Actions......................................................................
  @action
  void loadingStarted(){
    this._loadingDataFromDbOrServer = true;
  }

  @action
  void loadingFinished(){
    this._loadingDataFromDbOrServer = false;
  }

  @action
  Future<List<AppStep>> getStepsFromDb() async {
    try {
      fetchStepsFuture = ObservableFuture(_repository.getStepsFromDb());
      List<AppStep> steps = await fetchStepsFuture;
      _setStepList(steps);
      return steps;
    } catch (e) {
      return List.empty();
    }
  }

  @action
  Future<List<AppStep>> getStepsFromApi() async {
    try {
      fetchStepsFuture = ObservableFuture(_repository.getStepFromApiAndInsert());
      List<AppStep> steps = await fetchStepsFuture;
      _setStepList(steps);
      return steps;
    } catch (e) {
      return List.empty();
    }
  }

  void _setStepList(List<AppStep> steps) {
    steps.sort((a, b) => a.order.compareTo(b.order));
    this.stepList = ObservableList.of(steps);
  }

  AppStep getStepById(int stepId) {
    return this.getAllSteps.firstWhere((step) => step.id == stepId);
  }

  bool isFirstStep(int stepId) {
    var steps = this.getAllSteps;
    if(steps.isEmpty) {
      // Handle the empty list case. Return false or throw an exception.
      return false;
    }
    return steps.reduce((curr, next) => curr.order < next.order ? curr : next)
        .id == stepId;
  }

  int getIndexOfStep(int stepId){
    return this.getAllSteps.indexWhere((step) => step.id == stepId);
  }

  AppStep getStepByIndex(int index){
    return this.getAllSteps.elementAt(index);
  }

  Future<bool> isDataSourceEmpty() async {
    return (await _repository.stepDatasourceCount()) == 0;
  }

  @action
  Future<void> truncateSteps() async {
    await _repository.truncateStep();
  }

  //Tasks Actions: .............................................................
  List<Task> getAllTasks() {
    return this.getAllSteps.expand((step) => step.tasks).toList();
  }

  Task getTaskById(int id) {
    return getAllTasks().firstWhere((task) => task.id == id);
  }

  @action
  Future<void> toggleTask(Task task) async {
    task.toggleDone();
    AppStep step = getAllSteps.firstWhere((step) => step.id == task.step_id);
    _repository.updateStep(step);
  }

  @action
  Future<void> updateTask(Task task) async {
    AppStep step = getAllSteps.firstWhere((step) => step.id == task.step_id);
    int indexOfTask = step.tasks.indexWhere((t) => t.id == task.id);
    if (indexOfTask != -1) {
      step.tasks[indexOfTask] = task;
    }
    _repository.updateStep(step);

  }

  //Questions Actions: .........................................................
  List<Question> getAllQuestions() {
    return this.getAllSteps.expand((step) => step.questions).toList();
  }

  @action
  Future<void> updateQuestion(Question question) async {
    AppStep step = getAllSteps.firstWhere((step) => step.id == question.step_id);
    int indexOfQuestion = step.questions.indexWhere((q) => q.id == question.id);

    if (indexOfQuestion != -1) {
      step.questions[indexOfQuestion] = question;
    }
    _repository.updateStep(step);
  }

  Question getQuestionById(int questionId) {
    return getAllQuestions().firstWhere((question) => question.id == questionId);
  }

  //Other: .....................................................................
  List<Task> getDoneTasks(int stepId) {
    return getAllTasks().where((task) => task.step_id == stepId && task.isDone).toList();
  }

  bool isAllTasksOfStepDone(int stepId){
    return this.getStepById(stepId).tasks.length == this.getDoneTasks(stepId).length;
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

  bool isLastStep(int stepId) {
    return this.getIndexOfStep(stepId) == this.getAllSteps.length - 1;
  }

}
