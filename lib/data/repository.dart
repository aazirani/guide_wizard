import 'dart:async';

import 'package:devicelocale/devicelocale.dart';
import 'package:guide_wizard/data/local/constants/db_constants.dart';
import 'package:guide_wizard/data/local/datasources/step/step_datasource.dart';
import 'package:guide_wizard/data/local/datasources/technical_name/technical_name_with_translations_datasource.dart';
import 'package:guide_wizard/data/local/datasources/updated_at_times/updated_at_times_datasource.dart';
import 'package:guide_wizard/data/network/apis/app_data/app_data_api.dart';
import 'package:guide_wizard/data/network/apis/tranlsation/translation_api.dart';
import 'package:guide_wizard/data/network/apis/updated_at_times/updated_at_times_api.dart';
import 'package:guide_wizard/data/sharedpref/shared_preference_helper.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/step/step_list.dart';
import 'package:guide_wizard/models/technical_name/technical_name_with_translations.dart';
import 'package:guide_wizard/models/technical_name/technical_name_with_translations_list.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';
import 'package:sembast/sembast.dart';

class Repository {
  // data source object
  final StepDataSource _stepDataSource;
  final TechnicalNameWithTranslationsDataSource
      _technicalNameWithTranslationsDataSource;
  final UpdatedAtTimesDataSource _updatedAtTimesDataSource;

  // api objects
  final StepApi _stepApi;
  final TechnicalNameApi _technicalNameApi;
  final UpdatedAtTimesApi _updatedAtTimesApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  Repository(
    this._stepApi,
    this._updatedAtTimesApi,
    this._sharedPrefsHelper,
    this._stepDataSource,
    this._technicalNameApi,
    this._technicalNameWithTranslationsDataSource,
    this._updatedAtTimesDataSource,
  );

  // Step: ---------------------------------------------------------------------

  Future<List<AppStep>> getStepsFromDb() async {
    if (await _stepDataSource.count() > 0) {
      return _stepDataSource.getStepsFromDb().then((appStepList) => appStepList.steps);
    } else {
      // Return an empty list or handle this case differently, without making an API call
      return List.empty();
    }
  }

  Future<List<AppStep>> getStepFromApiAndInsert() async {
    AppStepList stepList = await _stepApi.getSteps(await getUrlParameters());
    List<AppStep> existingSteps = await getStepsFromDb(); // This should not loop now
    return updateContent(existingSteps, stepList.steps);
  }


  Future<List<AppStep>> updateContent(List<AppStep> stepsBeforeUpdate, List<AppStep> stepsAfterUpdate) async {
    await this.truncateContent();
    // Extract IDs of selected answers from stepsBeforeUpdate
    var selectedAnswerIds = stepsBeforeUpdate
        .expand((step) => step.questions)
        .expand((question) => question.answers)
        .where((answer) => answer.isSelected)
        .map((answer) => answer.id)
        .toSet(); // Using a set to make lookups faster

    // Set isSelected to true for answers in stepsAfterUpdate with matching IDs
    stepsAfterUpdate
        .expand((step) => step.questions)
        .expand((question) => question.answers)
        .where((answer) => selectedAnswerIds.contains(answer.id))
        .forEach((answer) => answer.setSelected(true));

    for (AppStep step in stepsAfterUpdate) {
      await _stepDataSource.insert(step);
    }
    return stepsAfterUpdate;
  }


  Future stepDatasourceCount() async {
    return await _stepDataSource.count().catchError((error) => throw error);
  }

  Future technicalNameWithTranslationsDatasourceCount() async {
    return await _technicalNameWithTranslationsDataSource.count().catchError((error) => throw error);
  }

  Future truncateStep() =>
      _stepDataSource.deleteAll().catchError((error) => throw error);

  Future<int> insertStep(AppStep step) => _stepDataSource
      .insert(step)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> updateStep(AppStep step) => _stepDataSource
      .update(step)
      .then((id) => id)
      .catchError((error) => throw error);

  Future<int> deleteStep(AppStep step) => _stepDataSource
      .delete(step)
      .then((id) => id)
      .catchError((error) => throw error);

  // TranslationsWithTechnicalName: ---------------------------------------------------------------------
  Future<TechnicalNameWithTranslationsList> getTechnicalNameWithTranslationsFromDb() async {
    return await technicalNameWithTranslationsDatasourceCount() > 0
        ? _technicalNameWithTranslationsDataSource.getTranslationsFromDb()
        : getTechnicalNameWithTranslationsFromApiAndInsert();
  }

  Future<TechnicalNameWithTranslationsList> getTechnicalNameWithTranslationsFromApiAndInsert() async {
    TechnicalNameWithTranslationsList technicalNameWithTranslationsList = await _technicalNameApi.getTechnicalNamesWithTranslations(await getUrlParameters());
    technicalNameWithTranslationsList.technicalNameWithTranslations.forEach((technicalNameWithTranslations) async {
      _technicalNameWithTranslationsDataSource
          .insert(technicalNameWithTranslations);
    });
    return technicalNameWithTranslationsList;
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

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<String> changeLanguage(String value) =>
      _sharedPrefsHelper.changeLanguage(value);

  String? get currentLanguage => _sharedPrefsHelper.currentLanguage;

  Future<String?> getCurrentLocale() async {
    if (currentLanguage != null) {
      return currentLanguage;
    } else {
      return await Devicelocale.currentLocale;
    }
  }

  bool isUpdated(String maybeUpdated, String old) {
    return maybeUpdated != old;
  }

  // UpdatedAtTimes: -----------------------------------------------------------------
  /*
  Future updateContentIfNeeded({forceUpdate = false}) async {
    UpdatedAtTimes originUpdatedAt = await getUpdatedAtTimesFromApi();

    if (forceUpdate || await isContentUpdated()) {
      getStepFromApiAndInsert();
    }
    await truncateUpdatedAtTimes();
    await _updatedAtTimesDataSource.insert(originUpdatedAt);
  }

  Future<UpdatedAtTimes> getTheLastUpdatedAtTimes() async {
    return await _updatedAtTimesDataSource.count() > 0
        ? _updatedAtTimesDataSource.getUpdatedAtTimesFromDb()
        : getUpdatedAtTimesFromApi();
  }
   */

  Future<UpdatedAtTimes> getUpdatedAtTimesFromDB() async {
    if(await _updatedAtTimesDataSource.count() < 1){
      return await getUpdatedAtTimesFromApiAndInsert();
    }
    return await _updatedAtTimesDataSource.getUpdatedAtTimesFromDb();
  }

  Future<UpdatedAtTimes> getUpdatedAtTimesFromApiAndInsert() async {
    UpdatedAtTimes updatedAtTimes =
        await _updatedAtTimesApi.getUpdatedAtTimes(await getUrlParameters());

    return await updateUpdatedAtTimes(updatedAtTimes);
  }

  Future<UpdatedAtTimes> updateUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) async {
    await this.truncateUpdatedAtTimes();
    _updatedAtTimesDataSource.insert(updatedAtTimes);

    return updatedAtTimes;
  }

  Future truncateUpdatedAtTimes() =>
      _updatedAtTimesDataSource.deleteAll().catchError((error) => throw error);

  Future truncateContent() async {
    await truncateStep();
    await truncateTechnicalNameWithTranslations();
  }

  // Current Step Number: -----------------------------------------------------------------
  Future<int> setCurrentStepId(int stepId) async {
    await _sharedPrefsHelper.setCurrentStepId(stepId);
    return stepId;
  }

  int? get currentStepId => _sharedPrefsHelper.currentStepId;

  //URL Parameters: ----------------------------------------------------------------------
  Future<String> getUrlParameters() async {
    List<AppStep> steps = await getStepsFromDb();
    if(steps.isEmpty){
      return "";
    }
    return steps
        .expand((step) => step.questions)
        .expand((question) =>
        question.answers.where((answer) => answer.isSelected))
        .map((answer) => answer.id)
        .toList()
        .join(",");
  }

  // Must Update Value: ------------------------------------------------------------------
  bool? get getAnswerWasUpdated => _sharedPrefsHelper.answerWasUpdated;

  Future<void> setAnswerWasUpdated(bool answerWasUpdated) =>
      _sharedPrefsHelper.setAnswerWasUpdated(answerWasUpdated);
}
