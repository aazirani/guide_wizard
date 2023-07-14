import 'dart:async';
import 'dart:io';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/stores/updated_at_times/updated_at_times_store.dart';
import 'package:boilerplate/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:boilerplate/widgets/step_slider/step_slider_widget.dart';
import 'package:boilerplate/widgets/step_timeline/step_timeline.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late LanguageStore _languageStore;
  late UpdatedAtTimesStore _updatedAtTimesStore;
  late CurrentStepStore _currentStepStore;
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _languageStore = Provider.of<LanguageStore>(context);
    _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context);
    _currentStepStore = Provider.of<CurrentStepStore>(context);
  }

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    Future.delayed(Duration(milliseconds: 000), () async {
      _languageStore.init();
      _technicalNameWithTranslationsStore
          .getCurrentLan(_languageStore.language_id!);
      print(_languageStore.locale);

      // Loading data (from datasource if data is downloaded before):
      await _loadDataWithoutErrorHandling(context); // TODO: delete this one
      // Checking whether there is an update:
      await _checkForUpdate(context);
      // Loading data (from datasource if data is downloaded before):
      await _loadDataWithoutErrorHandling(context);

    });
  }

  SimpleFontelicoProgressDialog? _dialog;

  Future<bool> _canConnectToServer() async {
    bool ActiveConnection = false;
    try {
      final result = await InternetAddress.lookup(Endpoints.baseUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
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

  Future _checkForUpdate(BuildContext context) async {
    // Warning: We may need these comments later!

    // _dialog ??= SimpleFontelicoProgressDialog(context: context);
    // _dialog!.show(
    //     message: AppLocalizations.of(context).translate("loading_dialog_text"),
    //     type: SimpleFontelicoProgressDialogType.normal,
    //     horizontal: true,
    //     width: 175.0,
    //     height: 75.0,
    //     hideText: false,
    //     indicatorColor: Colors.red);
    // _dialog!.hide();
    if (!_updatedAtTimesStore.loading) {
      await _updatedAtTimesStore.updateContentIfNeeded(); //TODO: handle network exception here
    }
    // _dialog!.hide();
  }

  Future _loadDataWithoutErrorHandling(BuildContext context) async {
    _dialog ??= SimpleFontelicoProgressDialog(context: context);
    _dialog!.show(
        message: AppLocalizations.of(context).translate("loading_dialog_text"),
        type: SimpleFontelicoProgressDialogType.normal,
        horizontal: true,
        width: 175.0,
        height: 75.0,
        hideText: false,
        indicatorColor: AppColors.main_color);
    if (!_dataStore.stepLoading) {
      await _technicalNameWithTranslationsStore.getTechnicalNameWithTranslations();
      await _dataStore.getSteps();
      await _currentStepStore.setStepsCount(_dataStore.stepList.steps.length);
      await _dataStore.getAllTasks();
      await _dataStore.getQuestions();
    }
    _dialog!.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

//appbar build methods .........................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      backgroundColor: AppColors.main_color,
      title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(AppLocalizations.of(context).translate("steps_title"),
              style: TextStyle(color: AppColors.title_color, fontSize: 20))),
    );
  }

//body build methods ...........................................................
  Widget _buildBody(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 251, 251),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: _buildScreenElements(),
      ),
    );
  }

  Widget _buildScreenElements() {
    return Column(
      children: [
        //steps (/)
        _buildCurrentStepIndicator(),
        //step slider
        Observer(
            builder: (_) => StepSliderWidget(stepList: _dataStore.stepList)),
        // StepSliderWidget(),
        //step timeline
        //TODO: save current and pending steps in shared preferences
        StepTimeLine(
          stepNo: _currentStepStore.stepsCount,
        ),
        SizedBox(height: 25),
        _buildInProgressText(),
        SizedBox(height: 10),
        //task compressed timeline
        Observer(
            builder: (_) =>
                CompressedTasklistTimeline(stepList: _dataStore.stepList)),
      ],
    );
  }

  Widget _buildCurrentStepIndicator() {
    return Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
        ),
        child: Row(children: [
          _buildStepsText(),
          SizedBox(width: 10),
          _buildCurrentStepText(_stepStore),
        ]));
  }

  Widget _buildStepsText() {
    return Text(AppLocalizations.of(context).translate("steps"),
        style: TextStyle(
            color: AppColors.main_color,
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }

  Widget _buildCurrentStepText(stepStore) {
    return Observer(
        builder: (_) => Text("${stepStore.currentStep}/${_currentStepStore.stepsCount}",
            style: TextStyle(color: AppColors.main_color)));
  }

  Widget _buildInProgressText() {
    return Padding(
        padding: EdgeInsets.only(left: 20, top: 10),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate("in_progress"),
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.main_color,
                    fontWeight: FontWeight.bold))));
  }

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
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
