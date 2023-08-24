import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_laod_handler.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:guide_wizard/widgets/step_slider/step_slider_widget.dart';
import 'package:guide_wizard/widgets/step_timeline/step_timeline.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Stores :---------------------------------------------------------------------
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late LanguageStore _languageStore;
  late AppSettingsStore _appSettingsStore;
  late DataLoadHandler _dataLoadHandler;

  // Getters :---------------------------------------------------------------------
  get _getScreenHeight => MediaQuery.of(context).size.height;
  get _getScreenWidth => MediaQuery.of(context).size.width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _languageStore = Provider.of<LanguageStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _dataLoadHandler = DataLoadHandler(context: context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 000), () async {
      await _dataLoadHandler.loadDataAndCheckForUpdate();
      _languageStore.init();
      _technicalNameWithTranslationsStore.setCurrentLocale(_languageStore.locale);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColors.main_color,
        onRefresh: () async {
          DataLoadHandler(context: context).checkTimeAndForceUpdate();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -_buildAppBar().preferredSize.height - MediaQuery.of(context).padding.top,
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

//appbar build methods .........................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      backgroundColor: AppColors.main_color,
      actions: _buildActions(context),
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Observer(
          builder: (_) => Text(
              _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.steps_title),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
    ];
  }
  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
      color: Colors.white,
    );
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: Dimens.buttonRadius,
        enableFullWidth: true,
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _technicalNameWithTranslationsStore.getSupportedLanguages()
            .map(
              (object) => ListTile(
            dense: true,
            contentPadding: EdgeInsets.all(0.0),
            title: Text(
              object.language_name,
              style: Theme.of(context).textTheme.bodySmall
            ),
            onTap: () {
              Navigator.of(context).pop();
              // change user language based on selected locale
              _languageStore.changeLanguage(object.language_code);
              _technicalNameWithTranslationsStore.setCurrentLocale(object.language_code);
            },
          ),
        )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }

//body build methods ...........................................................
  Widget _buildBody(BuildContext context) {
    return Observer(
      builder: (_) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.homeBodyBorderRadius),
            topRight: Radius.circular(Dimens.homeBodyBorderRadius)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.homeBodyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.homeBodyBorderRadius),
              topRight: Radius.circular(Dimens.homeBodyBorderRadius),
            ),
          ),
          child: _dataStore.dataLoad
              ? _buildScreenElements(
              _appSettingsStore.currentStepNumber, _dataStore.values!)
              : _shimmerAll(),
        ),
      ),
    );
  }

  Widget _shimmerAll() {
    return Shimmer(
      period: Duration(seconds: 3),
      gradient: LinearGradient(
        colors: [
          AppColors.shimmerGradientGreys[50]!,
          AppColors.shimmerGradientGreys[100]!,
          AppColors.shimmerGradientGreys[200]!,
        ],
        begin: Alignment(-1, -1),
        end: Alignment(1, 1),
        stops: [0.5, 0.75, 1],
      ),
      child: _buildPlaceholderScreenElements(),
    );
  }

  Widget _buildScreenElements(int current, values) {
    _languageStore.changeLanguage(_languageStore.locale);
    _technicalNameWithTranslationsStore.setCurrentLocale(_languageStore.locale);
    return Observer(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCurrentStepIndicator(),
          StepSliderWidget(stepList: _dataStore.stepList),
          StepTimeLine(
            stepNo: _appSettingsStore.stepsCount,
          ),
           _stepStore.currentStep == 1
               ?_buildQuestionDescription()
               : _buildInProgressCompressedTaskList(),
        ],
      ),
    );
  }

  Widget _buildCurrentStepIndicator() {
    return Padding(
      padding: Dimens.currentStepIndicatorPadding,
      child: Row(
        children: [
        _buildStepsText(),
        SizedBox(width: 10),
        _buildCurrentStepText(_stepStore),
        ]
      ),
    );
  }

  Widget _buildStepsText() {
    return Text(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.steps),
        style: Theme.of(context).textTheme.titleSmall,
            );
  }

  Widget _buildCurrentStepText(stepStore) {
    return Observer(
        builder: (_) => Text(
            "${stepStore.currentStep}/${_appSettingsStore.stepsCount}",
            style: Theme.of(context).textTheme.titleSmall
            )
            );
  }

  Widget _buildQuestionDescription() {
    int questionDescId = _dataStore.stepList.steps[0].description;
    return Observer(
      builder: (_) => Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: Dimens.inProgressTextPadding,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.description),
                        style: Theme.of(context).textTheme.titleSmall))),
            Flexible(
              child: Container(
                margin: Dimens.questionsStepDescMargin,
                padding: Dimens.questionsStepDescPadding,
                decoration: BoxDecoration(
                  color: AppColors.timelineCompressedContainerColor,
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
                ),
                child: RawScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _technicalNameWithTranslationsStore.getTranslation(questionDescId),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInProgressCompressedTaskList() {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: Dimens.inProgressTextPadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.in_progress),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: Dimens.compressedTaskListPadding,
              child: CompressedTasklistTimeline(stepList: _dataStore.stepList),
            ),
          ),
        ],
      ),
    );
  }

  _buildPlaceholderScreenElements() {
    return Column(
      children: [
        _buildPlaceholderCurrentStepIndicator(),
        _buildPlaceholderCarouselSliderContainer(),
        StepTimeLine(stepNo: 0),
        SizedBox(height: Dimens.StepTimelineProgressBarDistance),
        // _buildInProgressCompressedTaskList(),
        SizedBox(height: Dimens.progressBarCompressedTaskListDistance),
        _buildPlaceholderCompressedTasklistTimeline(),
      ],
    );
  }

  _buildPlaceholderCurrentStepIndicator() {
    return Padding(
        padding: Dimens.currentStepIndicatorPadding,
        child: Row(children: [
          _buildStepsText(),
        ]));
  }

  Widget _buildPlaceholderCarouselSliderContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: Dimens.placeHolderCarouselSliderContainerPadding,
      height: MediaQuery.of(context).size.height /
          Dimens.placeHolderCarouselSliderHeightRatio,
      child: _buildPlaceholderStepSliderWidget(),
    );
  }

  Widget _buildPlaceholderStepSliderWidget() {
    return CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          alignment: Alignment.topLeft,
          width: _getScreenWidth,
          margin: Dimens.sliderContainerMargin,
          padding: Dimens.sliderContainerPadding,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.placeHolderStepSliderBorderRadius)),
          ),
        );
      },
      options: CarouselOptions(
        height: _getScreenHeight / Dimens.placeHolderCarouselHeightRatio,
        initialPage: 0,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildPlaceholderCompressedTasklistTimeline() {
    return Padding(
      padding: Dimens.stepTimelineContainerPadding,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.compressedTaskListBorderRadius))),
        padding: Dimens.timelineContainerPadding,
        height: _getScreenHeight /
            Dimens.placeHolderCompressedTaskListHeightRatio,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }
}
