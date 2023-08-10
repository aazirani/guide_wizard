import 'dart:async';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/stores/app_settings/app_settings_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:boilerplate/widgets/measure_size.dart';
import 'package:boilerplate/widgets/step_slider/step_slider_widget.dart';
import 'package:boilerplate/widgets/step_timeline/step_timeline.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

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
  late AppSettingsStore _appSettingsStore;
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
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
    _dataLoadHandler = DataLoadHandler(context: context);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 000), () async {
      _languageStore.init();
      _technicalNameWithTranslationsStore.getCurrentLan(_languageStore.language_id!);
      print(_languageStore.locale);
      await _dataLoadHandler.loadDataAndCheckForUpdate();
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
            height: MediaQuery.of(context).size.height - _buildAppBar().preferredSize.height - MediaQuery.of(context).padding.top,
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
      title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(AppLocalizations.of(context).translate("steps_title"),
              style: TextStyle(color: AppColors.title_color, fontSize: 20))),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCurrentStepIndicator(),
        Observer(
            builder: (_) => StepSliderWidget(stepList: _dataStore.stepList)),
        Observer(
          builder: (_) => StepTimeLine(
            stepNo: _appSettingsStore.stepsCount,
          ),
        ),
        _stepStore.isQuestionStep() ? _buildQuestionDescription() : _buildInProgressCompressedTaskList(),
      ],
    );
  }

  Widget _buildCurrentStepIndicator() {
    return Padding(
        padding: Dimens.currentStepIndicatorPadding,
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
            fontSize: Dimens.stepsTextFont,
            fontWeight: FontWeight.bold));
  }

  Widget _buildCurrentStepText(stepStore) {
    return Observer(
        builder: (_) => Text(
            "${stepStore.currentStep}/${_appSettingsStore.stepsCount}",
            style: TextStyle(color: AppColors.main_color)));
  }

  double descriptionWidgetHeight = 0;
  Widget _buildQuestionDescription() {
    int questionDescId = _dataStore.stepList.steps[0].description;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: Dimens.inProgressTextPadding,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context).translate("description"),
                    style: TextStyle(
                        fontSize: Dimens.inProgressTextFont,
                        color: AppColors.main_color,
                        fontWeight: FontWeight.bold)))),

        Container(
          height: math.min(descriptionWidgetHeight, MediaQuery.of(context).size.height / 3),
          // width: _getScreenWidth() / 1.23,
          margin: const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.timelineCompressedContainerColor,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
          ),
          child: SingleChildScrollView(
            child: MeasureSize(
              onChange: (Size size) {
                setState(() {
                  descriptionWidgetHeight = size.height;
                });
              },
              child: Flexible(
                child: Text(
                  _technicalNameWithTranslationsStore.getTranslation(questionDescId),
                  style: TextStyle(
                    color: AppColors.main_color,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInProgressCompressedTaskList() {
    return Column(
      children: [
        Padding(
            padding: Dimens.inProgressTextPadding,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context).translate("in_progress"),
                    style: TextStyle(
                        fontSize: Dimens.inProgressTextFont,
                        color: AppColors.main_color,
                        fontWeight: FontWeight.bold)))),
        Observer(builder: (_) => CompressedTasklistTimeline(stepList: _dataStore.stepList)),
      ],
    );
  }

  _buildPlaceholderScreenElements() {
    return Column(
      children: [
        _buildPlaceholderCurrentStepIndicator(),
        _buildPlaceholderCarouselSliderContainer(),
        StepTimeLine(stepNo: 0),
        SizedBox(height: Dimens.StepTimelineProgressBarDistance),
        _buildInProgressCompressedTaskList(),
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
          width: _getScreenWidth(),
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
        height: _getScreenHeight() / Dimens.placeHolderCarouselHeightRatio,
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
        color: Colors.grey,
        padding: Dimens.timelineContainerPadding,
        height: _getScreenHeight() /
            Dimens.placeHolderCompressedTaskListHeightRatio,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }

  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
