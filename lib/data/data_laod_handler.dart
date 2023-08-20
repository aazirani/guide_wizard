import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/constants/necessary_strings.dart';
import 'package:guide_wizard/constants/settings.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class DataLoadHandler { // This class is SINGLETON
  late BuildContext context;
  int criticalId = 0; // for handling processes entering the loadDataAndCheckForUpdate function!
  static DataLoadHandler? _instance;

  DataLoadHandler._(this.context);

  // Warning: It has to be called with main context before further usage
  factory DataLoadHandler({BuildContext? context}) => _instance ??= DataLoadHandler._(context!);

  //stores:---------------------------------------------------------------------
  late DataStore _dataStore = Provider.of<DataStore>(context, listen: false);
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore =Provider.of<TechnicalNameWithTranslationsStore>(context, listen: false);
  late UpdatedAtTimesStore _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context, listen: false);
  late AppSettingsStore _appSettingsStore = Provider.of<AppSettingsStore>(context, listen: false);

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

  Future loadDataAndCheckForUpdate({int processId = 0}) async {
    bool hasInternetConnection = await hasInternet();
    bool thereIsNoLocalData = await hasNoLocalData();
    bool mustUpdate = await isUpdateNecessary();
    if (!hasInternetConnection && thereIsNoLocalData && processId == criticalId && !mustUpdate) {
      showNoInternetError();
      Future.delayed(SettingsConstants.internetCheckingPeriod, () {
        loadDataAndCheckForUpdate(processId: processId);
      });
    }
    else if (thereIsNoLocalData || !hasInternetConnection) {
      ScaffoldMessenger.of(context).clearSnackBars();
      await loadData();
      if(mustUpdate) {
        await checkIfUpdateIsNecessary();
      }
    }
    else if(mustUpdate) {
      await checkIfUpdateIsNecessary();
    }
    else{
      await checkForUpdate();
    }
    if(_dataStore.getAllTasks().isEmpty){
      await _dataStore.getAllTasks();
    }
  }

  Future<bool> hasInternet() async => await InternetConnectionChecker().hasConnection;

  Future<bool> hasNoLocalData() async => await _dataStore.isDataSourceEmpty();

  Future<bool> isUpdateNecessary() async => await _appSettingsStore.getMustUpdate() ?? false;

  void showServerErrorMessage() {
    showErrorMessage(
        messageWidgetObserver: Observer(builder: (_) {
          String text = _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.cant_reach_server);
          return Text(text.isNotEmpty ? text : NecessaryStrings.cant_reach_server);
        }),
        onPressedButton: () {
          loadDataAndCheckForUpdate(processId: ++criticalId);
        }
    );
  }

  void showNoInternetError() {
    showErrorMessage(
        messageWidgetObserver: Observer(builder: (_) {
          String text = _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.no_internet_message);
          return Text(text.isNotEmpty ? text : NecessaryStrings.no_internet_message);
        }),
        onPressedButton: () {
          loadDataAndCheckForUpdate(processId: ++criticalId);
        }
    );
  }

  Future checkForUpdate({forceUpdate = false}) async {
    await updateContentIfNeeded(forceUpdate: forceUpdate); // Checks whether there is an update and will insert it in database
    await loadData(); // Loads the new data from datasource if update was occurred
  }

  Future loadData() async {
    _dataStore.dataNotLoaded();
    if (!_dataStore.stepLoading) {
      await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslations();
      await _dataStore.getStepsFromApi();
    }
    if (_dataStore.stepSuccess && !_dataStore.stepLoading) {
      _dataStore.dataLoaded();
      await _appSettingsStore.setCurrentStepId(_dataStore.getAllSteps().first.id);
    }
  }

  Future updateContentIfNeeded({forceUpdate = false}) async {
    await _updatedAtTimesStore.updateContentIfNeeded(forceUpdate: forceUpdate);
  }

  Future<void> checkIfUpdateIsNecessary() async {
    bool mustUpdate = await isUpdateNecessary();
    bool hasInternetConnection = await hasInternet();
    if(mustUpdate) {
      if(!hasInternetConnection){
        DataLoadHandler().showErrorMessage(
            duration: Duration(milliseconds: 5000),
            messageWidgetObserver: Observer(builder: (_) {
              String text = _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.update_is_necessary_message_text);
              return Text(text.isNotEmpty ? text : NecessaryStrings.update_is_necessary_message_text);
            }),
            onPressedButton: () {
              checkIfUpdateIsNecessary();
            }
        );
      }
      else {
        forceUpdate();
      }
    }
  }

  void forceUpdate() async {
    await checkForUpdate(forceUpdate: true);
    await _appSettingsStore.setMustUpdate(false);
  }

  Future<void> checkTimeAndForceUpdate() async {
    await updateContentIfNeeded(forceUpdate: await isUpdateNecessary()); // Checks whether there is an update and will insert it in database
    await loadData(); // Loads the new data from datasource if update was occurred
  }
}
