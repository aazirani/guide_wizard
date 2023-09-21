import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/language/language_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/stores/updated_at_times/updated_at_times_store.dart';
import 'package:guide_wizard/widgets/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:guide_wizard/widgets/step_slider/step_slider_widget.dart';
import 'package:guide_wizard/widgets/step_timeline/step_timeline.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

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
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late LanguageStore _languageStore;
  late UpdatedAtTimesStore _updatedAtTimesStore;
  late AppSettingsStore _appSettingsStore;
  late DataLoadHandler _dataLoadHandler = DataLoadHandler(context: context);

  // Getters :---------------------------------------------------------------------
  get _getScreenHeight => MediaQuery.of(context).size.height;
  get _getScreenWidth => MediaQuery.of(context).size.width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _languageStore = Provider.of<LanguageStore>(context);
    _updatedAtTimesStore = Provider.of<UpdatedAtTimesStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  void initState() {
    _dataLoadHandler.loadDataAndCheckForUpdate(initialLoading: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.primaryColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: context.primaryColor,
        onRefresh: () async {
          DataLoadHandler(context: context).loadDataAndCheckForUpdate(refreshData: true);
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
      toolbarHeight: Dimens.appBar.toolbarHeight,
      titleSpacing: Dimens.appBar.titleSpacing,
      backgroundColor: context.primaryColor,
      actions: _buildActions(context),
      title: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Observer(
          builder: (_) => Text(
              _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.steps_title),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
      child: Observer(
        builder: (_) => MaterialDialog(
          borderRadius: Dimens.homeScreen.buttonRadius,
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
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
          topRight: Radius.circular(Dimens.homeScreen.bodyBorderRadius)),
      child: Observer(
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: context.lightBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
              topRight: Radius.circular(Dimens.homeScreen.bodyBorderRadius),
            ),
          ),
          child: !_dataStore.isEmpty && !_dataStore.isLoading && !_technicalNameWithTranslationsStore.technicalNameLoading && !_updatedAtTimesStore.updatedAtTimesLoading && _dataStore.stepSuccess && _technicalNameWithTranslationsStore.technicalNameSuccess && _updatedAtTimesStore.updatedAtTimesSuccess
              ? _buildScreenElements()
              : _shimmerAll(),
        ),
      ),
    );
  }

  Widget _shimmerAll() {
    return Shimmer.fromColors(
      baseColor: context.shimmerBaseColor,
      highlightColor: context.shimmerHeighlightColor,
      child: _buildPlaceholderScreenElements(),
    );
  }

  Widget _buildScreenElements() {
    _languageStore.changeLanguage(_languageStore.locale);
    _technicalNameWithTranslationsStore.setCurrentLocale(_languageStore.locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCurrentStepIndicator(),
        StepSliderWidget(),
        StepTimeLine(),
        _dataStore.isFirstStep(_appSettingsStore.currentStepId) ? _buildQuestionDescription() : _buildInProgressCompressedTaskList(),
      ],
    );
  }

  Widget _buildCurrentStepIndicator() {
    return Padding(
        padding: Dimens.homeScreen.currentStepIndicatorPadding,
        child: Row(children: [
          _buildStepsText(),
          SizedBox(width: 10),
          _buildCurrentStepText(),
        ]));
  }

  Widget _buildStepsText() {
    return Text(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.steps),
        style: Theme.of(context).textTheme.titleSmall);
  }

  Widget _buildCurrentStepText() {
    return Text(
        "${_dataStore.getAllSteps.indexWhere((step) => step.id == _appSettingsStore.currentStepId) + 1}/${_dataStore.getAllSteps.length}",
        style: Theme.of(context).textTheme.titleSmall);
  }

  Widget _buildQuestionDescription() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: Dimens.homeScreen.inProgressTextPadding,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.description),
                      style: Theme.of(context).textTheme.titleSmall
                          )
                          )),

          Flexible(
            child: Container(
              margin: Dimens.homeScreen.questionsStepDescMargin,
              padding: Dimens.homeScreen.questionsStepDescPadding,
              decoration: BoxDecoration(
                color: context.containerColor,
                borderRadius: BorderRadius.all(Radius.circular(Dimens.compressedTaskList.contentRadius)),
              ),
              child: RawScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          _technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepById(_appSettingsStore.currentStepId).description),
                          style: Theme.of(context).textTheme.bodyMedium
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
    );
  }

  Widget _buildInProgressCompressedTaskList() {
    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: Dimens.homeScreen.inProgressTextPadding,
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
              padding: Dimens.compressedTaskList.padding,
              child: CompressedTaskListTimeline(),
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
         _buildPlaceholderStepTimeline(),
        SizedBox(height: Dimens.homeScreen.StepTimelineProgressBarDistance),
        SizedBox(height: Dimens.homeScreen.progressBarCompressedTaskListDistance),
        _buildPlaceholderCompressedTaskListTimeline(),
      ],
    );
  }

  _buildPlaceholderStepTimeline(){
    return Padding(
      padding: Dimens.stepTimeLine.containerPadding,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
            color: context.containerColor,
            borderRadius: Dimens.stepTimeLine.containerBorderRadius,
            boxShadow: [
              BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 0.3,
                  offset: Offset(0, 2))
            ]),
      ),
    );

  }

  _buildPlaceholderCurrentStepIndicator() {
    return Padding(
        padding: Dimens.homeScreen.currentStepIndicatorPadding,
        child: Row(children: [
          _buildStepsText(),
        ]));
  }

  Widget _buildPlaceholderCarouselSliderContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: Dimens.homeScreen.placeHolderCarouselSliderContainerPadding,
      height: MediaQuery.of(context).size.height /
          Dimens.homeScreen.placeHolderCarouselSliderHeightRatio,
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
          margin: Dimens.stepSlider.sliderContainerMargin,
          padding: Dimens.stepSlider.sliderContainerPadding,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.homeScreen.placeHolderStepSliderBorderRadius)),
          ),
        );
      },
      options: CarouselOptions(
        height: _getScreenHeight / Dimens.homeScreen.placeHolderCarouselHeightRatio,
        initialPage: 0,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _buildPlaceholderCompressedTaskListTimeline() {
    return Padding(
      padding: Dimens.stepTimeLine.containerPadding,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(Dimens.homeScreen.compressedTaskListBorderRadius))),
        padding: Dimens.compressedTaskList.timelineContainerPadding,
        height: _getScreenHeight /
            Dimens.homeScreen.placeHolderCompressedTaskListHeightRatio,
        width: double.infinity,
        child: Align(
          alignment: Alignment.topLeft,
        ),
      ),
    );
  }
}
