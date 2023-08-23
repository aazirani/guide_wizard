import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/constants/settings.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/models/step/step_list.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/questions/questions_list_page.dart';
import 'package:guide_wizard/ui/tasklist/tasklist.dart';
import 'package:guide_wizard/widgets/load_image_with_cache.dart';
import 'package:provider/provider.dart';

class StepSliderWidget extends StatefulWidget {
  StepList stepList;
  StepSliderWidget({Key? key, required this.stepList}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildCarouselSliderContainer();
  }

  Widget _buildCarouselSliderContainer() {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.of(context).size.height / 3.2,
      child: _buildCarouselSlider(),
    );
  }
  final CarouselController _carouselController = CarouselController();
  _buildCarouselSlider() {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
          initialPage: _stepStore.currentStep - 1,
          onPageChanged: (index, reason) {
            _stepStore.increment(index);
          },
          height: _getScreenHeight() / 4,
          enlargeCenterPage: false,
          enableInfiniteScroll: false),
      items:
      List<int>.generate(_dataStore.stepList.steps.length, (index) => index)
          .map((index) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                _carouselController.animateToPage(index);
              },
              child: _buildSliderContainer(index),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSliderContainer(index) {
    return Container(
        alignment: Alignment.topLeft,
        width: _getScreenWidth(),
        margin: Dimens.sliderContainerMargin,
        decoration: BoxDecoration(
          color: _buildSliderColor(index),
          border: _buildSliderBorder(index),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildContent(index),
                  _buildAvatar(index),
                ],
              ),
            ),
            (_dataStore.getStepOrder(index) != SettingsConstants.infoStepOrder) ? _buildProgressBar(index) : SizedBox(),
          ],
        ));
  }

  BoxBorder _buildSliderBorder(index) {
    if (index < _appSettingsStore.currentStepNumber)
      return _buildDoneBorder();
    else if (index == _appSettingsStore.currentStepNumber)
      return _buildPendingBorder();
    return _buildNotStartedBorder();
  }

  Color _buildSliderColor(index) {
    if (index <= _appSettingsStore.currentStepNumber) {
      return AppColors.stepSliderAvailableColor;
    }
    return AppColors.stepSliderUnavailableColor;
  }

  Widget _buildAvatar(int index) {
    if (_dataStore.getStepImage(index) == null) return SizedBox();
    return Flexible(
      child: Container(
        margin: Dimens.stepSliderImagePadding,
        child: Padding(
          padding: Dimens.stepAvatar,
          child: LoadImageWithCache(imageUrl: Endpoints.stepsImageBaseUrl +
              _dataStore.getStepImage(index)!,
            color: AppColors.main_color,),
        ),
      ),
    );
  }

  Widget _buildContent(currentStepNo) {
    return Flexible(
      child: Padding(
        padding: Dimens.sliderContainerContentPadding,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: SingleChildScrollView(child: _buildStepTitle(currentStepNo)),
              ),
              SizedBox(height: 10),
              _buildStepNoOfTasksOrQuestions(currentStepNo),
              SizedBox(height: 20),
              _buildContinueButton(currentStepNo),
            ]),
      ),
    );
  }

  Widget _buildStepTitle(currentStepNo) {
    var step_title_id = _dataStore.stepList.steps[currentStepNo].name;
    return Text(
      "${_technicalNameWithTranslationsStore.getTranslation(step_title_id)}",
      style: TextStyle(
          fontSize: Dimens.stepTitleFont, color: AppColors.main_color),
    );
  }

  Widget _buildStepNoOfTasksOrQuestions(currentStepNo) {
    return Text(
        isQuestionsStep(currentStepNo) ? noOfQuestionsString(currentStepNo) : noOfTasksString(currentStepNo),
        style: TextStyle(
          fontSize: Dimens.numOfTasksFont, color: AppColors.main_color,
        )
    );
  }

  bool isQuestionsStep(currentStepNo) => isFirstStep(currentStepNo);
  bool isFirstStep(currentStepNo) => currentStepNo == 0;

  String noOfTasksString(currentStepNo) {
    int noOfTasks = _dataStore.getNumberOfTasksFromAStep(currentStepNo);
    String str = "$noOfTasks ";
    switch (noOfTasks) {
      case 1: str += _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.task); break;
      default: str += _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.tasks); break;
    }
    return str;
  }

  String noOfQuestionsString(currentStepNo) {
    int noOfQuestions = _dataStore.getNumberOfQuestionsFromAStep(currentStepNo);
    String str = "$noOfQuestions ";
    switch (noOfQuestions) {
      case 1: str += _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.question); break;
      default: str += _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.questions); break;
    }
    return str;
  }

  Widget _buildContinueButton(currentStepNo) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 3.5,
        ),
        child: TextButton(
          style: _buildButtonStyle(),
          onPressed: () {
            if (currentStepNo == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => QuestionsListPage(stepNumber: currentStepNo,)));
            } else {
              var stepId = _dataStore.getStepId(currentStepNo);
              _dataStore.getTasks(stepId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskList(
                        currentStepNo: currentStepNo,
                      )));
            }
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.continueKey),
                    style: TextStyle(
                        fontSize: Dimens.continueFont, color: AppColors.main_color)),
                SizedBox(width: 1),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.main_color,
                  size: 16,
                )
              ]),
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(AppColors.stepSliderContinueButton.withOpacity(0.5)),
      overlayColor: MaterialStateColor.resolveWith((states) => AppColors.green[100]!.withOpacity(0.3)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.buttonRadius),
          side: BorderSide(color: AppColors.main_color),
        ),
      ),
    );
  }

  Widget _buildProgressBar(currentStepNo) {
    return Container(
      height: Dimens.progressBarHeight,
      margin: Dimens.stepSliderProgressBarPadding,
      child: Observer(
        builder: (_) => Padding(
            padding: Dimens.stepSliderprogressBarPadding,
            child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(Dimens.progressBarRadius)),
              child: LinearProgressIndicator(
                // minHeight: 4,
                  value: _dataStore.values![currentStepNo],
                  backgroundColor: AppColors.progressBarBackgroundColor,
                  valueColor:
                  AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
            )),
      ),
    );
  }

  Border _buildPendingBorder() {
    return Border.all(
        width: Dimens.pendingSliderBorder, color: AppColors.main_color);
  }

  Border _buildDoneBorder() {
    return Border.all(
        width: Dimens.doneSliderBorder, color: AppColors.main_color);
  }

  Border _buildNotStartedBorder() {
    return Border.all(
        width: Dimens.notStartedSliderBorder,
        color: AppColors.stepSliderUnavailableBorder);
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}