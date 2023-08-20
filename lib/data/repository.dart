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
    return await _stepDataSource.getStepsFromDb().then((appStepList) => appStepList.steps);
  }

  Future<List<AppStep>> getStepFromApiAndInsert() async {

    AppStepList stepList = await _stepApi.getSteps(await getUrlParameters());
    return await updateContent((await getStepsFromDb()), stepList.steps);
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
  Future<TechnicalNameWithTranslationsList>
      getTechnicalNameWithTranslations() async {
    return await _technicalNameWithTranslationsDataSource.count() > 0
        ? _technicalNameWithTranslationsDataSource.getTranslationsFromDb()
        : _technicalNameApi
            .getTechnicalNamesWithTranslations(await getUrlParameters())
            .then((t) {
            t.technicalNameWithTranslations
                .forEach((technicalNameWithTranslations) async {
              _technicalNameWithTranslationsDataSource
                  .insert(technicalNameWithTranslations);
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

  // Theme: --------------------------------------------------------------------
  Future<void> changeBrightnessToDark(bool value) =>
      _sharedPrefsHelper.changeBrightnessToDark(value);

  bool get isDarkMode => _sharedPrefsHelper.isDarkMode;

  // Language: -----------------------------------------------------------------
  Future<void> changeLanguage(String value) =>
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
  Future<bool> isContentUpdated() async {
    UpdatedAtTimes localUpdatedAt = await getTheLastUpdatedAtTimes();
    UpdatedAtTimes originUpdatedAt = await getUpdatedAtTimesFromApi();
    bool isContentUpdated = isUpdated(originUpdatedAt.last_updated_at_content,
        localUpdatedAt.last_updated_at_content);
    bool isTranslationUpdated = isUpdated(
        originUpdatedAt.last_updated_at_technical_names,
        localUpdatedAt.last_updated_at_technical_names);
    return isContentUpdated || isTranslationUpdated;
  }

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

  Future<UpdatedAtTimes> getUpdatedAtTimesFromDB() async {
    return await _updatedAtTimesDataSource.getUpdatedAtTimesFromDb();
  }

  Future<UpdatedAtTimes> getUpdatedAtTimesFromApi() async {
    UpdatedAtTimes updatedAtTimes =
        await _updatedAtTimesApi.getUpdatedAtTimes(await getUrlParameters());
    return updatedAtTimes;
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

  Future<int> insertUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) =>
      _updatedAtTimesDataSource
          .insert(updatedAtTimes)
          .then((id) => id)
          .catchError((error) => throw error);

  Future<int> updateUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) =>
      _updatedAtTimesDataSource
          .update(updatedAtTimes)
          .then((id) => id)
          .catchError((error) => throw error);

  Future<int> deleteUpdatedAtTimes(UpdatedAtTimes updatedAtTimes) =>
      _updatedAtTimesDataSource
          .delete(updatedAtTimes)
          .then((id) => id)
          .catchError((error) => throw error);

  Future truncateUpdatedAtTimes() =>
      _updatedAtTimesDataSource.deleteAll().catchError((error) => throw error);

  Future truncateContent() async {
    await truncateStep();
    await truncateTechnicalNameWithTranslations();
  }

  // Current Step Number: -----------------------------------------------------------------
  Future<void> setCurrentStepId(int stepId) =>
      _sharedPrefsHelper.setCurrentStepId(stepId);

  int? get currentStepId => _sharedPrefsHelper.currentStepId;

  //URL Parameters: ----------------------------------------------------------------------
  Future<String> getUrlParameters() async {
    return this.getStepsFromDb().then((steps) {
      return steps
          .expand((step) => step.questions)
          .expand((question) =>
              question.answers.where((answer) => answer.isSelected))
          .map((answer) => answer.id)
          .toList()
          .join(",");
    });
  }

  // Must Update Value: ------------------------------------------------------------------
  bool? get getMustUpdate => _sharedPrefsHelper.mustUpdate;

  Future<void> setMustUpdate(bool mustUpdate) =>
      _sharedPrefsHelper.setMustUpdate(mustUpdate);
}
