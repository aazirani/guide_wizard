import 'dart:async';
import 'package:boilerplate/data/local/datasources/post/post_datasource.dart';
import 'package:boilerplate/data/local/datasources/step/step_datasource.dart';
import 'package:boilerplate/data/local/datasources/task/task_datasource.dart';
import 'package:boilerplate/data/local/datasources/sub_task/sub_task_datasource.dart';
import 'package:boilerplate/data/local/datasources/question/question_datasource.dart';
import 'package:boilerplate/data/local/datasources/technical_name/technical_name_datasource.dart';
import 'package:boilerplate/data/local/datasources/technical_name/technical_name_with_translations_datasource.dart';
import 'package:boilerplate/data/local/datasources/updated_at_times/updated_at_times_datasource.dart';
import 'package:boilerplate/data/network/apis/tranlsation/translation_api.dart';
import 'package:boilerplate/data/network/apis/updated_at_times/updated_at_times_api.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/models/post/post.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/translation/translation.dart';
import 'package:boilerplate/models/technical_name/technical_name_with_translations_list.dart';
import 'package:boilerplate/models/technical_name/technical_name_with_translations.dart';
import 'package:boilerplate/models/updated_at_times/updated_at_times.dart';
import 'package:sembast/sembast.dart';
import 'package:boilerplate/models/answer/answer.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'package:boilerplate/models/sub_task/sub_task_list.dart';
import 'package:boilerplate/models/task/task_list.dart';
import 'local/constants/db_constants.dart';
import 'network/apis/posts/post_api.dart';
import 'network/apis/app_data/app_data_api.dart';
import 'package:boilerplate/models/step/step.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/services.dart';

class Repository {
  // data source object
  final PostDataSource _postDataSource;
  final TechnicalNameDataSource _technicalNameDataSource;
  final StepDataSource _stepDataSource;
  final TaskDataSource _taskDataSource;
  final SubTaskDataSource _subTaskDataSource;
  final QuestionDataSource _questionDataSource;
  final TechnicalNameWithTranslationsDataSource _technicalNameWithTranslationsDataSource;
  final UpdatedAtTimesDataSource _updatedAtTimesDataSource;

  // api objects
  final PostApi _postApi;
  final StepApi _stepApi;
  final UpdatedAtTimesApi _updatedAtTimesApi;

  // api objects
  final TechnicalNameApi _technicalNameApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(
    this._postApi,
    this._stepApi,
    this._updatedAtTimesApi,
    this._sharedPrefsHelper,
    this._postDataSource,
    this._stepDataSource,
    this._taskDataSource,
    this._subTaskDataSource,
    this._questionDataSource,
    this._technicalNameApi,
    this._technicalNameDataSource,
    this._technicalNameWithTranslationsDataSource,
    this._updatedAtTimesDataSource,
  );

  // Step: ---------------------------------------------------------------------
  Future<StepList> getStep() async {
    return await _stepDataSource.count() > 0
        ? _stepDataSource.getStepsFromDb()
        : getStepFromApi();
  }


  Future<StepList> getStepFromApi() async {
    await truncateContent();
    StepList stepList = await _stepApi.getSteps();
    for (Step step in stepList.steps) {
      await _stepDataSource.insert(step);
      for (Task task in step.tasks) {
        await _taskDataSource.insert(task);
        await _insertItems(task.sub_tasks, _subTaskDataSource.insert);
        await _insertItems(task.questions, _questionDataSource.insert);
      }
    }
    return stepList;
  }

  Future<void> _insertItems<T>(List<T> items, Future<void> Function(T) insertFunction) async {
    for (T item in items) {
      await insertFunction(item);
    }
  }


  Future stepDatasourceCount() =>
      _stepDataSource.count().catchError((error) => throw error);

  Future truncateStep() =>
      _stepDataSource.deleteAll().catchError((error) => throw error);

  Future<int> insertStep(Step step) => _stepDataSource
      .insert(step)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateStep(Step step) => _stepDataSource
      .update(step)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteStep(Step step) => _stepDataSource
      .delete(step)
      .then((id) => id)
      .catchError((error) => throw error);

  // Task: ---------------------------------------------------------------------
  Future<TaskList> getTasks() async {
    return await _taskDataSource.getTasksFromDb();
  }

  Future<TaskList> getTasksFromApi() async {
    List<Task> tasks = [];
    return await getStepFromApi().then((stepList) {
      stepList.steps.forEach((step) {
        step.tasks.forEach((task) {
          tasks.add(task);
        });
      });
      TaskList taskList = TaskList(tasks: tasks);
      return taskList;
    });
  }

  Future<TaskList> getUpdatedTask() async {
    return await getTasksFromApi().then((taskList) async {
      List<int> taskID = [];
      taskList.tasks.forEach((task) async {
        await findTaskById(task.id).then((value) {
          if (value.length > 0) {
            if (value.first.isDone) {
              taskID.add(task.id);
            }
          }
        });
      });
      if (taskID.length > 0) {
        for (Task task in taskList.tasks) {
          if (taskID.contains(task.id)) {
            task.isDone = true;
          }
        }
      }
      await truncateTask().then((value) {
        for (Task task in taskList.tasks) {
          _taskDataSource.insert(task);
        }
      });
      return taskList;
    });
  }

  Future<List<Task>> findTaskById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _taskDataSource
        .getAllSortedByFilter(filters: filters)
        .then((tasks) => tasks)
        .catchError((error) => throw error);
  }

  Future truncateTask() =>
      _taskDataSource.deleteAll().catchError((error) => throw error);

  Future<int> insertTask(Task task) => _taskDataSource
      .insert(task)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateTask(Task task) => _taskDataSource
      .update(task)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteTask(Task task) => _taskDataSource
      .delete(task)
      .then((id) => id)
      .catchError((error) => throw error);

  // SubTask: ------------------------------------------------------------------
  Future<SubTaskList> getSubTask() async {
    return await _subTaskDataSource.count() > 0
        ? _subTaskDataSource.getSubTasksFromDb()
        : getStepFromApi().then((stepList) {
            List<SubTask> subTasks = [];
            SubTaskList subTaskList = SubTaskList(subTasks: []);
            stepList.steps.forEach((step) {
              step.tasks.forEach((task) {
                task.sub_tasks.forEach((subTask) {
                  subTasks.add(subTask);
                  insertSubTask(subTask);
                });
              });
            });
            subTaskList.setSubTasks = subTasks;
            return subTaskList;
          });
  }

  Future<int> insertSubTask(SubTask subTask) => _subTaskDataSource
      .insert(subTask)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateSubTask(SubTask subTask) => _subTaskDataSource
      .update(subTask)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteSubTask(SubTask subTask) => _subTaskDataSource
      .delete(subTask)
      .then((id) => id)
      .catchError((error) => throw error);

  Future truncateSubTask() =>
      _subTaskDataSource.deleteAll().catchError((error) => throw error);

  // Question: -----------------------------------------------------------------
  Future<QuestionList> getQuestions() async {
    return await _questionDataSource.getQuestionsFromDb();
  }

  Future<QuestionList> getQuestionsFromApi() async {
    List<Question> questions = [];
    return await getTasksFromApi().then((taskList) {
      taskList.tasks.forEach((task) {
        task.questions.forEach((question) {
          questions.add(question);
          _questionDataSource.insert(question);
        });
      });
      QuestionList questionList = QuestionList(questions: questions);
      return questionList;
    });
  }

  Future<QuestionList> getUpdatedQuestion() async {
    List<Question> questions = [];
    QuestionList questionsList = QuestionList(questions: []);
    return await getQuestionsFromApi().then((questionList) async {
      questionList.questions.forEach((question) async {
        questions.add(question);
        List<int> selectedAnswers = [];
        await findQuestionByID(question.id).then((value) async {
          if (value.length > 0) {
            for (Answer answer in value.first.answers) {
              if (answer.selected) {
                selectedAnswers.add(answer.id);
              }
            }
          }
          if (selectedAnswers.length > 0) {
            for (Answer answer in question.answers) {
              if (selectedAnswers.contains(answer.id)) {
                answer.selected = true;
              }
            }
          } else {
            for (Answer answer in question.answers) {
              if (answer.is_enabled) {
                answer.selected = true;
                break;
              }
            }
          }
        });
      });
      await truncateQuestions().then((value) {
        for (Question question in questionList.questions) {
          _questionDataSource.insert(question);
        }
      });
      questionsList.setQuestions = questions;
      return questionList;
    });
  }

  Future<List<Question>> findQuestionByID(int id) {
    //creating filter
    List<Filter> filters = [];

    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _questionDataSource
        .getAllSortedByFilter(filters: filters)
        .then((questions) => questions)
        .catchError((error) => throw error);
  }

  Future<int> insertQuestion(Question question) => _questionDataSource
      .insert(question)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateQuestion(Question question) => _questionDataSource
      .update(question)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteQuestion(Question question) => _questionDataSource
      .delete(question)
      .then((id) => id)
      .catchError((error) => throw error);

  Future truncateQuestions() =>
      _questionDataSource.deleteAll().catchError((error) => throw error);
  // Post: ---------------------------------------------------------------------
  Future<PostList> getPosts() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    return await _postApi.getPosts().then((postsList) {
      postsList.posts?.forEach((post) {
        _postDataSource.insert(post);
      });

      return postsList;
    }).catchError((error) => throw error);
  }

  Future<List<Post>> findPostById(int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _postDataSource
        .getAllSortedByFilter(filters: filters)
        .then((posts) => posts)
        .catchError((error) => throw error);
  }

  Future<int> insert(Post post) => _postDataSource
      .insert(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> update(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> delete(Post post) => _postDataSource
      .update(post)
      .then((id) => id)
      .catchError((error) => throw error);

  // TranslationsWithTechnicalName: ---------------------------------------------------------------------
  Future<TechnicalNameWithTranslationsList> getTechnicalNameWithTranslations() async {
    // check to see if posts are present in database, then fetch from database
    // else make a network call to get all posts, store them into database for
    // later use
    await truncateTechnicalNameWithTranslations();
    return await _technicalNameWithTranslationsDataSource.count() > 0
        ? _technicalNameWithTranslationsDataSource.getTranslationsFromDb()
        : _technicalNameApi
            .getTechnicalNamesWithTranslations()
            .then((t) {
          t.technicalNameWithTranslations.forEach((technicalNameWithTranslations) async {
            _technicalNameWithTranslationsDataSource
                .insert(technicalNameWithTranslations);
            // translationWithStepName.translations.forEach((translation) {
            //   _languageDataSource.insert(translation.language);
            // });
          });

      return t;
    }).catchError((error) => throw error);
  }

  Future<List<TechnicalNameWithTranslations>> findTechnicalNameWithTranslations(
      int id) {
    //creating filter
    List<Filter> filters = [];

    //check to see if dataLogsType is not null
    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _technicalNameWithTranslationsDataSource
        .getAllSortedByFilter(filters: filters)
        .then((technicalNameWithTranslations) => technicalNameWithTranslations)
        .catchError((error) => throw error);
  }

  Future<int?> insertTranslationWithStepName(
          TechnicalNameWithTranslations translation) =>
      _technicalNameWithTranslationsDataSource
          .insert(translation)
          .then((id) => id)
          .catchError((error) => throw error);

  Future<int> updateTranslationWithStepName(
          TechnicalNameWithTranslations translation) =>
      _technicalNameWithTranslationsDataSource
          .update(translation)
          .then((id) => id)
          .catchError((error) => throw error);

  Future<int> deleteTranslationWithStepName(
          TechnicalNameWithTranslations translation) =>
      _technicalNameWithTranslationsDataSource
          .delete(translation)
          .then((id) => id)
          .catchError((error) => throw error);

  Future truncateTechnicalNameWithTranslations() =>
      _technicalNameWithTranslationsDataSource
          .deleteAll()
          .catchError((error) => throw error);

  // Login:---------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    return await Future.delayed(Duration(seconds: 2), () => true);
  }

  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;

  // Future<void> _initPlatformState() async {
  //   _getCurrentLocale();
  //   _getDefaultLocale();
  //   _getPreferredLanguages();
  // }

  Future<String?> _getDefaultLocale() async {
    try {
      final defaultLocale = await Devicelocale.defaultLocale;
      print((defaultLocale != null)
          ? defaultLocale
          : "Unable to get defaultLocale");
      return defaultLocale;
    } on PlatformException {
      print("Error obtaining default locale");
    }
  }

  Future<String?> getCurrentLocale() async {
    return await Devicelocale.currentLocale;
  }

  Future<dynamic> _getPreferredLanguages() async {
    try {
      final languages = await Devicelocale.preferredLanguages;
      print((languages != null)
          ? languages
          : "unable to get preferred languages");
      return languages;
    } on PlatformException {
      print("Error obtaining preferred languages");
    }
  }

  bool isUpdated(String maybeUpdated, String old){
    if(maybeUpdated.compareTo(old) == 1){
      return true;
    }
    return false;
  }

  bool isNotUpdated(String maybeUpdated, String old){
    return !isUpdated(maybeUpdated, old);
  }

  // UpdatedAtTimes: -----------------------------------------------------------------
  Future<bool> isContentUpdated(UpdatedAtTimes originUpdatedAt) async{
    UpdatedAtTimes localUpdatedAt = await getTheLastUpdatedAtTimes();
    // UpdatedAtTimes originUpdatedAt = await getUpdatedAtTimesFromApi();
    // StepList stepList = await getStep();
    // String contentUpdatedAt = stepList.steps.first.name.updated_at;
    print("origin: " + originUpdatedAt.last_updated_at_content);
    print("local: " + localUpdatedAt.last_updated_at_content);
    return isUpdated(originUpdatedAt.last_updated_at_content, localUpdatedAt.last_updated_at_content);
    // (await getStep()).steps.map((e) {
    //   if(originUpdatedAt.last_updated_at_content.compareTo(localUpdatedAt.last_updated_at_content) == 1){
    //     return true;
    //   }
    // });
    return false;
  }

  Future updateContentIfNeeded() async{
    UpdatedAtTimes originUpdatedAt = await getUpdatedAtTimesFromApi();
    if(await isContentUpdated(originUpdatedAt)){
      StepList _stepList = await getStep();
      await truncateContent();
      await _stepApi.getSteps().then((stepList) {
        stepList.steps.forEach((step) {
          _stepDataSource.insert(step);
          step.tasks.forEach((task) {
            _taskDataSource.insert(task);
            task.sub_tasks.forEach((subTask) {
              _subTaskDataSource.insert(subTask);
            });
            task.questions.forEach((question) {
              Question? foundOldQuestion = _stepList.findQuestionByID(question.id);
              if(foundOldQuestion != null){
                _questionDataSource.insert(foundOldQuestion);
              }
              else{
                _questionDataSource.insert(question);
              }
            });
          });
        });
      });
      await truncateUpdatedAtTimes();
      await _updatedAtTimesDataSource.insert(originUpdatedAt);
    }
  }

  Future<UpdatedAtTimes> getTheLastUpdatedAtTimes() async {
    return await _updatedAtTimesDataSource.count() > 0
        ? _updatedAtTimesDataSource.getUpdatedAtTimesFromDb()
        : getUpdatedAtTimesFromApi();
  }

  Future<UpdatedAtTimes> getUpdatedAtTimesFromDB() async {
    return await _updatedAtTimesDataSource.getUpdatedAtTimesFromDb();
  }

  Future<UpdatedAtTimes> getUpdatedAtTimesFromApi() async {
    return await _updatedAtTimesApi.getUpdatedAtTimes().then((updatedAtTimes) {
      return updatedAtTimes;
    });
  }

  Future<List<UpdatedAtTimes>> findUpdatedAtTimesByID(int id) {
    //creating filter
    List<Filter> filters = [];

    Filter dataLogTypeFilter = Filter.equals(DBConstants.FIELD_ID, id);
    filters.add(dataLogTypeFilter);

    //making db call
    return _updatedAtTimesDataSource
        .getAllSortedByFilter(filters: filters)
        .then((updatedAtTimes) => updatedAtTimes)
        .catchError((error) => throw error);
  }

  Future<int> insertUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) => _updatedAtTimesDataSource
      .insert(updatedAtTimes)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) => _updatedAtTimesDataSource
      .update(updatedAtTimes)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) => _updatedAtTimesDataSource
      .delete(updatedAtTimes)
      .then((id) => id)
      .catchError((error) => throw error);

  Future truncateUpdatedAtTimes() =>
      _updatedAtTimesDataSource.deleteAll().catchError((error) => throw error);

  Future truncateContent() async{
    await truncateStep();
    await truncateTask();
    await truncateSubTask();
    await truncateQuestions();
    await truncateTechnicalNameWithTranslations();
  }

  // Current Step Number: -----------------------------------------------------------------
  Future<void> setCurrentStep(int value) =>
      _sharedPrefsHelper.setCurrentStep(value);

  int? get currentStepNumber => _sharedPrefsHelper.currentStepNumber;

  Future<void> setStepsCount(int value) =>
      _sharedPrefsHelper.setStepsCount(value);

  int? get stepsCount => _sharedPrefsHelper.stepsCount;


}