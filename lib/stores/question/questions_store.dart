import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'questions_store.g.dart';

class QuestionsStore = _QuestionsStore with _$QuestionsStore;

abstract class _QuestionsStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _QuestionsStore(Repository repository) : this._repository = repository;

  // store variables:-----------------------------------------------------------
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
  QuestionList? questionList;

  @observable
  bool success = false;

  @computed
  bool get loading => fetchQuestionsFuture.status == FutureStatus.pending;

  @computed
  bool get loadingTruncate => truncateQuestionsFuture.status == FutureStatus.pending;

  // actions:-------------------------------------------------------------------
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

  Future truncateTable() async {
    final future = _repository.truncateQuestions();
    truncateQuestionsFuture = ObservableFuture(future);

    future.catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

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

}
