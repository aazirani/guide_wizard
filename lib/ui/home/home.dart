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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:shimmer/shimmer.dart';

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
    return Observer(
      builder: (_) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.homeBodyBorderRadius), topRight: Radius.circular(Dimens.homeBodyBorderRadius)),
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
              ? _buildScreenElements()
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
                  child: _buildPlaceholderScreenElements(),);
  }

  Widget _buildScreenElements() {
    return Column(
      children: [
        _buildCurrentStepIndicator(),
        Observer(
            builder: (_) => StepSliderWidget(stepList: _dataStore.stepList)),

        Observer(
          builder: (_) => StepTimeLine(
            stepNo: _currentStepStore.stepsCount,
          ),
        ),
        SizedBox(height: 25),
        _buildInProgressText(),
        SizedBox(height: 10),
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
        builder: (_) => Text(
            "${stepStore.currentStep}/${_currentStepStore.stepsCount}",
            style: TextStyle(color: AppColors.main_color)));
  }

  Widget _buildInProgressText() {
    return Padding(
        padding: Dimens.inProgressTextPadding,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(AppLocalizations.of(context).translate("in_progress"),
                style: TextStyle(
                    fontSize: Dimens.inProgressTextFont,
                    color: AppColors.main_color,
                    fontWeight: FontWeight.bold))));
  }

  _buildPlaceholderScreenElements() {
    return Column(
    children: [
      _buildCurrentStepIndicator(),
      _buildPlaceholderCarouselSliderContainer(),
      StepTimeLine(stepNo: 0),
      SizedBox(height: 25),
      _buildInProgressText(),
      SizedBox(height: 10),
      _buildPlaceholderCompressedTasklistTimeline(),
    ],
  );
  }

  Widget _buildPlaceholderCarouselSliderContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: Dimens.placeHolderCarouselSliderContainerPadding,
      height: MediaQuery.of(context).size.height / Dimens.placeHolderCarouselSliderHeightRatio,
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
          borderRadius: BorderRadius.all(Radius.circular(Dimens.placeHolderStepSliderBorderRadius)),
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
        height: _getScreenHeight() / Dimens.placeHolderCompressedTaskListHeightRatio,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
        ),
      ),
  );
}

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
