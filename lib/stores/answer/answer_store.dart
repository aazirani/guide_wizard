import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/step/step.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/stores/error/error_store.dart';
import 'package:boilerplate/utils/dio/dio_error_util.dart';
import 'package:mobx/mobx.dart';

part 'answer_store.g.dart';

class AnswerStore = _AnswerStore with _$AnswerStore;

abstract class _AnswerStore with Store {
  // repository instance
  Repository _repository;

  // store for handling errors
  final ErrorStore errorStore = ErrorStore();

  // constructor:---------------------------------------------------------------
  _AnswerStore(Repository repository) : this._repository = repository;

  @observable
  List<Answer> answers = [];

  @observable
  bool success = false;

  // actions:-------------------------------------------------------------------
  get getAnswers => answers;

  Future updateAnswers() async {
    final future = _repository.getStep();
    answers = [];
    future.then((stepList) {
      for(Step step in stepList.steps) {
        for(Task task in step.tasks) {
          for(Question question in task.questions) {
            for(Answer answer in question.answers) {
              if(answer.selected) {
                answers.add(answer);
              }
            }
          }
        }
      }
    }).catchError((error) {
      errorStore.errorMessage = DioErrorUtil.handleError(error);
    });

    return future;
  }

}
