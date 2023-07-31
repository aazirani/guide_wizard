import 'dart:async';
import 'package:boilerplate/constants/settings.dart';
import 'package:boilerplate/stores/app_settings/app_settings_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/stores/updated_at_times/updated_at_times_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  late AppSettingsStore _currentStepStore = Provider.of<AppSettingsStore>(context, listen: false);

  void showErrorMessage({required String message, String? buttonLabel}) {
    buttonLabel ??= AppLocalizations.of(context).translate("no_internet_button_text");
    final snackBar = SnackBar(
      duration: SettingsConstants.errorSnackBarDuration,
      dismissDirection: DismissDirection.none,
      content: Text(message),
      action: SnackBarAction(
          label: buttonLabel,
          onPressed: () {
            loadDataAndCheckForUpdate(processId: ++criticalId);
          }
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showServerErrorMessage() {
    showErrorMessage(message: AppLocalizations.of(context).translate("cant_reach_server"));
  }

  Future<bool> hasInternet() async => await InternetConnectionChecker().hasConnection;

  Future<bool> hasNoLocalData() async => await _dataStore.isDataSourceEmpty();

  Future loadDataAndCheckForUpdate({int processId = 0}) async {
    bool hasInternetConnection = await hasInternet();
    bool thereIsNoLocalData = await hasNoLocalData();
    if (!hasInternetConnection && thereIsNoLocalData && processId == criticalId) {
      showErrorMessage(message: AppLocalizations.of(context).translate("no_internet_message"));
      Future.delayed(SettingsConstants.internetCheckingPeriod, () {
        loadDataAndCheckForUpdate(processId: processId);
      });
    }
    else if (thereIsNoLocalData || !hasInternetConnection) {
      ScaffoldMessenger.of(context).clearSnackBars();
      await loadData();
    }
    else {
      await checkForUpdate();
    }
  }

  Future checkForUpdate() async {
    await updateContentIfNeeded(); // Checks whether there is an update and will insert it in database
    await loadData(); // Loads the new data from datasource if update was occurred
  }

  Future loadData() async {
    _dataStore.dataNotLoaded();
    if (!_dataStore.stepLoading) {
      await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslations();
      await _dataStore.getSteps();
      await _currentStepStore.setStepsCount(_dataStore.stepList.steps.length);
      // keep this comment for now:
      // await _dataStore.getAllTasks();
      await _dataStore.getQuestions();
      await _dataStore.initializeValues();
    }
    if (_dataStore.stepSuccess) {
      _dataStore.dataLoaded();
    }
  }

  Future updateContentIfNeeded() async {
    await _updatedAtTimesStore.updateContentIfNeeded();
  }
}
