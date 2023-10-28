import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/constants/necessary_strings.dart';
import 'package:guide_wizard/constants/settings.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DataLoadHandler {
  // This class is SINGLETON
  late BuildContext context;
  static DataLoadHandler? _instance;

  DataLoadHandler._(this.context);

  // Warning: It has to be called with main context before further usage
  factory DataLoadHandler({BuildContext? context}) => _instance ??= DataLoadHandler._(context!);

  int criticalId = 0; // for handling processes entering the loadDataAndCheckForUpdate function!

  //stores:---------------------------------------------------------------------
  late DataStore _dataStore = Provider.of<DataStore>(context, listen: false);
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context, listen: false);
  late UpdatedAtTimesStore _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context, listen: false);
  late AppSettingsStore _appSettingsStore = Provider.of<AppSettingsStore>(context, listen: false);

  Future<bool> hasInternet() async => kIsWeb || await InternetConnectionChecker().hasConnection;
  Future<bool> hasNoLocalData() async => await _dataStore.isDataSourceEmpty() || await _technicalNameWithTranslationsStore.isDataSourceEmpty();
  Future<bool> answerWasUpdated() async => await _appSettingsStore.getAnswerWasUpdated() ?? false;

  void showErrorMessage({required Widget messageWidgetObserver, String? buttonLabel, required var onPressedButton, Duration? duration}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    buttonLabel ??= _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.no_internet_button_text);
    duration ??= SettingsConstants.errorSnackBarDuration;
    final snackBar = SnackBar(
      duration: duration,
      dismissDirection: DismissDirection.none,
      content: messageWidgetObserver,
      action: SnackBarAction(
        label: buttonLabel.isNotEmpty
            ? buttonLabel
            : NecessaryStrings.no_internet_button_text,
        onPressed: onPressedButton,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Map<String, bool>> updatedAtWasChanged() async {
    UpdatedAtTimes oldUpdatedAtTimes =
        await _updatedAtTimesStore.getUpdatedAtTimesFromDb();

    if (DateTime.parse(oldUpdatedAtTimes.last_apps_request_time).isBefore(
        DateTime.now().subtract(SettingsConstants.updateRequestStop))) {
      UpdatedAtTimes newUpdatedAtTimes = await _updatedAtTimesStore.getUpdatedAtTimesFromApi();

      return {
        UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT:
            DateTime.parse(oldUpdatedAtTimes.last_updated_at_content).isBefore(DateTime.parse(newUpdatedAtTimes.last_updated_at_content)),
        UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES:
            DateTime.parse(oldUpdatedAtTimes.last_updated_at_technical_names).isBefore(DateTime.parse(newUpdatedAtTimes.last_updated_at_technical_names))
      };
    } else {
      return {
        UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT: false,
        UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES: false,
        UpdatedAtTimesFactory.LAST_APPS_REQUEST_TIME: false
      };
    }
  }

  Future loadDataAndCheckForUpdate({bool initialLoading = false, bool refreshData = false, int processId = 0}) async {
    // ****************** Web and App Conflict Implementation ******************
    if (kIsWeb) {
      await loadDataAndCheckForUpdate_Web(initialLoading: initialLoading, refreshData: refreshData, processId: processId);
    } else {
      await loadDataAndCheckForUpdate_App(initialLoading: initialLoading, refreshData: refreshData, processId: processId);
    }
    // *************************************************************************
  }

  Future loadDataAndCheckForUpdate_App({bool initialLoading = false, bool refreshData = false, int processId = 0}) async {
    if (_dataStore.isLoading) return;

    bool isAnswerWasUpdated = await answerWasUpdated();
    bool noLocalData = await hasNoLocalData();

    if(initialLoading) {
      if(!noLocalData) {
        _dataStore.loadingStarted();
        await loadDataFromDb();
        _dataStore.loadingFinished();
      }
      if(await hasInternet()) {
        _dataStore.loadingStarted();
        await updatedAtWasChanged().then((updatedAtTimesUpdatedMap) async => {
          if (updatedAtTimesUpdatedMap.length > 0 && updatedAtTimesUpdatedMap.values.any((updateAtChanged) => updateAtChanged)) {
            await loadDataFromApi(updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES]!, updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT]!)
          }
        });
        _dataStore.loadingFinished();
      }
    }
    if(noLocalData || isAnswerWasUpdated || refreshData) {
      if(await checkInternetConnectionAndShowMessage(processId: processId)) {
        ScaffoldMessenger.of(context).clearSnackBars();
        _dataStore.loadingStarted();
        await loadDataFromApi(true, true);
        _dataStore.loadingFinished();
      }
    }
  }


  Future loadDataAndCheckForUpdate_Web({bool initialLoading = false, bool refreshData = false, int processId = 0}) async {
    if (_dataStore.isLoading) return;

    bool isAnswerWasUpdated = await answerWasUpdated();
    bool noLocalData = await hasNoLocalData();

    if(initialLoading) {
      if(!noLocalData) {
        _dataStore.loadingStarted();
        await loadDataFromDb();
        _dataStore.loadingFinished();
      }
      _dataStore.loadingStarted();
      await updatedAtWasChanged().then((updatedAtTimesUpdatedMap) async => {
        if (updatedAtTimesUpdatedMap.length > 0 && updatedAtTimesUpdatedMap.values.any((updateAtChanged) => updateAtChanged)) {
          await loadDataFromApi(updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES]!, updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT]!)
        }
      });
      _dataStore.loadingFinished();
    }
    if(noLocalData || isAnswerWasUpdated || refreshData) {
      ScaffoldMessenger.of(context).clearSnackBars();
      _dataStore.loadingStarted();
      await loadDataFromApi(true, true);
      _dataStore.loadingFinished();
    }
  }

  Future<bool> checkInternetConnectionAndShowMessage({int processId = 0}) async {
    bool hasInternetConnection = await hasInternet();
    bool isAnswerWasUpdated = await answerWasUpdated();

    if(processId == criticalId){
      if(!hasInternetConnection) {
        if(isAnswerWasUpdated) {
          showUpdateRequiredMessage();
        }
        else {
          showNoInternetMessage(processId: processId);
        }
      }
    }

    return hasInternetConnection;
  }

  void showExceptionMessageWithBackgroundCheck({String ?text, required String backupText, int ?durationInMilliseconds, int processId = 0}) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    String text = _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.no_internet_message);
    showErrorMessage(
      duration: durationInMilliseconds != null ? Duration(milliseconds: durationInMilliseconds) : null,
      messageWidgetObserver: Text(text.isNotEmpty ? text : backupText),
      onPressedButton: () async {
        loadDataAndCheckForUpdate(processId: ++criticalId);
      }
    );
    Future.delayed(SettingsConstants.internetCheckingPeriod, () {
      loadDataAndCheckForUpdate(processId: processId);
    });
  }

  void showNoInternetMessage({int processId = 0}) {
    showExceptionMessageWithBackgroundCheck(
      text: _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.no_internet_message),
      backupText: NecessaryStrings.no_internet_message,
      processId: processId,
    );
  }

  void showServerErrorMessage() {
    showExceptionMessageWithBackgroundCheck(
      text: _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.cant_reach_server),
      backupText: NecessaryStrings.cant_reach_server,
    );
  }

  void showUpdateRequiredMessage() {
    showErrorMessage(
        duration: SettingsConstants.updateRequiredSnackBarDuration,
        messageWidgetObserver: Text(NecessaryStrings.update_is_necessary_message_text),
        onPressedButton: () {
          loadDataAndCheckForUpdate();
        }
    );
  }

  loadDataFromDb() async {
    await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslationsFromDb();
    List<AppStep> steps = await _dataStore.getStepsFromDb();
    if (steps.isNotEmpty) {
      if (_dataStore.stepIsDone(_dataStore.getStepByIndex(0).id))
        _appSettingsStore.setCurrentStepId(_dataStore.getStepByIndex(1).id);
      else {
        _appSettingsStore.setCurrentStepId(steps.first.id);
      }
    }
  }

  loadDataFromApi(
      bool technicalNamesShouldBeUpdated, bool contentsShouldBeUpdated) async {
    if (technicalNamesShouldBeUpdated &&
        !_technicalNameWithTranslationsStore.technicalNameLoading) {
      await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslationsFromApi();
    }
    if (contentsShouldBeUpdated && !_dataStore.stepLoading) {
      await _dataStore.getStepsFromApi().then((steps) async => {
            if (steps.isNotEmpty)
              {
                _appSettingsStore.setCurrentStepId(steps.first.id)
              }
          });
    }

    if (_technicalNameWithTranslationsStore.technicalNameSuccess &&
        _dataStore.stepSuccess) {
      await _appSettingsStore.setAnswerWasUpdated(false);
    }
  }
}
