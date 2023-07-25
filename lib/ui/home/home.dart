import 'dart:async';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:boilerplate/widgets/step_slider/step_slider_widget.dart';
import 'package:boilerplate/widgets/step_timeline/step_timeline.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
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
  late CurrentStepStore _currentStepStore;
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  late DataLoadHandler _dataLoadHandler;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _languageStore = Provider.of<LanguageStore>(context);
    _currentStepStore = Provider.of<CurrentStepStore>(context);
    _dataLoadHandler = DataLoadHandler(context);
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

      await _dataLoadHandler.loadDataAndCheckForUpdate();
    });
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
        Observer(
          builder: (_) => StepTimeLine(
            stepNo: _currentStepStore.stepsCount,
          ),
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
