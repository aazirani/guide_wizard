import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/constants/necessary_strings.dart';
import 'package:guide_wizard/constants/settings.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class DataLoadHandler { // This class is SINGLETON
  late BuildContext context;
  static DataLoadHandler? _instance;

  DataLoadHandler._(this.context);

  // Warning: It has to be called with main context before further usage
  factory DataLoadHandler({BuildContext? context}) => _instance ??= DataLoadHandler._(context!);

  //stores:---------------------------------------------------------------------
  late DataStore _dataStore = Provider.of<DataStore>(context, listen: false);
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore =Provider.of<TechnicalNameWithTranslationsStore>(context, listen: false);
  late UpdatedAtTimesStore _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context, listen: false);
  late AppSettingsStore _appSettingsStore = Provider.of<AppSettingsStore>(context, listen: false);
  late LanguageStore _languageStore = Provider.of<LanguageStore>(context, listen: false);

  Future<bool> hasInternet() async => await InternetConnectionChecker().hasConnection;
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
          label: buttonLabel.isNotEmpty ? buttonLabel : NecessaryStrings.no_internet_button_text,
          onPressed: onPressedButton,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Map<String, bool>> updatedAtWasChanged() async {
    UpdatedAtTimes oldUpdatedAtTimes = await _updatedAtTimesStore.getUpdatedAtTimesFromDb();
    UpdatedAtTimes newUpdatedAtTimes = await _updatedAtTimesStore.getUpdatedAtTimesFromApi();

    return {
      UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT : DateTime.parse(oldUpdatedAtTimes.last_updated_at_content).isBefore(DateTime.parse(newUpdatedAtTimes.last_updated_at_content)),
      UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES : DateTime.parse(oldUpdatedAtTimes.last_updated_at_technical_names).isBefore(DateTime.parse(newUpdatedAtTimes.last_updated_at_technical_names))
    };
  }

  Future loadDataAndCheckForUpdate({bool initialLoading = false}) async {
    _dataStore.loadingStarted();
    bool isAnswerWasUpdated = await answerWasUpdated();

    bool noLocalData = await hasNoLocalData();
    if(initialLoading){
      if(!noLocalData){
        await loadDataFromDb();
      }
      if(await checkInternetConnectionAndShowMessage()){
        await updatedAtWasChanged().then((updatedAtTimesUpdatedMap) async => {
          if (updatedAtTimesUpdatedMap.length > 0 && updatedAtTimesUpdatedMap.values.any((updateAtChanged) => updateAtChanged)) {
            await loadDataFromApi(updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_TECHNICAL_NAMES]!, updatedAtTimesUpdatedMap[UpdatedAtTimesFactory.LAST_UPDATED_AT_CONTENT]!)
          }
        });
      }
    }
    if((noLocalData || isAnswerWasUpdated) && await checkInternetConnectionAndShowMessage()){
      await loadDataFromApi(true, true);
      _dataStore.loadingFinished();
      return;
    }
    _dataStore.loadingFinished();
  }

  Future<bool> checkInternetConnectionAndShowMessage() async {
    bool hasInternetConnection = await hasInternet();
    if(!hasInternetConnection){
      showNoInternetMessage(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.update_is_necessary_message_text), NecessaryStrings.update_is_necessary_message_text, null);
    }
    return hasInternetConnection;
  }

  void showNoInternetMessage(String ?text, String backupText, int ?durationInMilliseconds) {
    ScaffoldMessenger.of(context).clearSnackBars();
    String text = _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.no_internet_message);
    showErrorMessage(
        duration: durationInMilliseconds != null ? Duration(milliseconds: durationInMilliseconds) : null,
        messageWidgetObserver: Text(text.isNotEmpty ? text : backupText),
        onPressedButton: () {
          loadDataAndCheckForUpdate();
        }
    );
    Future.delayed(SettingsConstants.internetCheckingPeriod, () {
      loadDataAndCheckForUpdate();
    });
  }

  loadDataFromDb() async {
    await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslationsFromDb();
    List<AppStep> steps = await _dataStore.getStepsFromDb();
    if(steps.isNotEmpty){
      await _appSettingsStore.setCurrentStepId(steps.first.id);
    }
  }

  loadDataFromApi(bool technicalNamesShouldBeUpdated, bool contentsShouldBeUpdated) async {
    if(technicalNamesShouldBeUpdated && !_technicalNameWithTranslationsStore.technicalNameLoading){
      await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslationsFromApi();
    }
    if(contentsShouldBeUpdated && !_dataStore.stepLoading){
      await _dataStore.getStepsFromApi().then((steps) async => {
        if(steps.isNotEmpty){
          await _appSettingsStore.setCurrentStepId(steps.first.id)
        }
      });
    }

    if(_technicalNameWithTranslationsStore.technicalNameSuccess && _dataStore.stepSuccess){
      await _appSettingsStore.setAnswerWasUpdated(false);
    }
  }
}
