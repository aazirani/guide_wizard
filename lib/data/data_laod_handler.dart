import 'dart:async';
import 'dart:io';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/stores/updated_at_times/updated_at_times_store.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class DataLoadHandler {
  late BuildContext _context;

  DataLoadHandler(this._context);

  //stores:---------------------------------------------------------------------
  late DataStore _dataStore = Provider.of<DataStore>(_context, listen: false);
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore =
      Provider.of<TechnicalNameWithTranslationsStore>(_context, listen: false);
  late UpdatedAtTimesStore _updatedAtTimesStore =
      Provider.of<UpdatedAtTimesStore>(_context, listen: false);
  late CurrentStepStore _currentStepStore =
      Provider.of<CurrentStepStore>(_context, listen: false);
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  Future loadDataAndCheckForUpdate() async {
    await loadData();
    await checkForUpdate();
  }

  Future loadData() async {
    // Loading data (from datasource if data is downloaded before):
    await _loadDataWithoutErrorHandling(); // TODO: delete this one by adding network exception handler to _checkForUpdate
  }

  Future checkForUpdate() async {
    // Checking whether there is an update:
    await _checkForUpdate();
    // Loading data (loads the new data from datasource if update was occurred):
    await _loadDataWithoutErrorHandling();
  }

  SimpleFontelicoProgressDialog? _dialog;

  Future<bool> _canConnectToServer() async {
    bool ActiveConnection = false;
    try {
      final result = await InternetAddress.lookup(Endpoints.baseUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ActiveConnection = true;
      }
    } on SocketException catch (_) {
      ActiveConnection = false;
    }
    return ActiveConnection;
  }

  Future<bool> _isConnectedToInternet() async {
    bool hasConnection;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        hasConnection = true;
        break;
      case ConnectivityResult.none:
      default:
        hasConnection = false;
    }
    return hasConnection;
  }

  void _showNoInternetConnectionDialog(BuildContext context) {
    _showAlertDialog(
        context,
        AppLocalizations.of(context).translate("no_internet_title"),
        AppLocalizations.of(context).translate("no_internet_content"),
        AppLocalizations.of(context).translate("no_internet_button_text"),
        _loadDataAndShowLoadingDialog);
  }

  void _showCantConnectToServer(BuildContext context) {
    _showAlertDialog(
        context,
        AppLocalizations.of(context).translate("unable_to_reach_server_title"),
        AppLocalizations.of(context)
            .translate("unable_to_reach_server_content"),
        AppLocalizations.of(context)
            .translate("unable_to_reach_server_button_text"),
        _loadDataAndShowLoadingDialog);
  }

  void _showAlertDialog(
      BuildContext context,
      String title,
      String content,
      String buttonText,
      void Function(BuildContext context) onPressedFunction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
                onPressedFunction(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _loadDataAndShowLoadingDialog(BuildContext context) async {
    _dialog ??= SimpleFontelicoProgressDialog(context: context);
    _dialog!.show(
        message: AppLocalizations.of(context).translate("loading_dialog_text"),
        type: SimpleFontelicoProgressDialogType.normal,
        horizontal: true,
        width: 175.0,
        height: 75.0,
        hideText: false,
        indicatorColor: AppColors.main_color);
    if (await _isConnectedToInternet()) {
      if (await _canConnectToServer()) {
        await _dataStore.getSteps();
        _dialog!.hide();
      } else {
        _dialog!.hide();
        _showCantConnectToServer(context);
      }
    } else {
      _dialog!.hide();
      _showNoInternetConnectionDialog(context);
    }
  }

  Future _checkForUpdate() async {
    if (!_updatedAtTimesStore.loading) {
      await _updatedAtTimesStore
          .updateContentIfNeeded(); //TODO: handle network exception here
    }
  }

  Future _loadDataWithoutErrorHandling() async {

    _dataStore.dataNotLoaded();
    if (!_dataStore.stepLoading) {
      await _technicalNameWithTranslationsStore
          .getTechnicalNameWithTranslations();
      await _dataStore.getSteps();
      await _currentStepStore.setStepsCount(_dataStore.stepList.steps.length);
      //keep this comment for now
      // await _dataStore.getAllTasks(); 
      await _dataStore.getQuestions();
      await _dataStore.initializeValues();
    }
    if (_dataStore.stepSuccess) {
      _dataStore.dataLoaded();
    }
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup(Endpoints.baseUrl);
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}
