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
import 'package:auto_size_text/auto_size_text.dart';

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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var heightConstraint = constraints.maxHeight;
      return Container(
        alignment: Alignment.topLeft,
        width: _getScreenWidth(),
        margin: Dimens.sliderContainerMargin,
        decoration: BoxDecoration(
          color: _buildSliderColor(index),
          border: _buildSliderBorder(index),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(children: [
          Flexible(
            flex: 80,
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: heightConstraint * 0.1,
                          left: heightConstraint * 0.1,
                          right: heightConstraint * 0.01,
                          bottom: heightConstraint * 0.05),
                      child: _buildContent(index, constraints))),
              (_dataStore.getStepImage(index) != null)
                  ? Expanded(flex: 1, child: _buildAvatar(index, constraints))
                  : Container(width: heightConstraint * 0.1)
            ]),
          ),
          (_dataStore.getStepOrder(index) != SettingsConstants.infoStepOrder)
              ? Flexible(flex: 10, child: _buildProgressBar(index))
              : Container(height: heightConstraint * 0.1),
        ]),
      );
    });
  }

  Widget _buildContent(index, constraints) {
    var heightConstraint = constraints.maxHeight;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          flex: 5,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Flexible(flex: 4, child: _buildStepTitle(index)),
            SizedBox(height: heightConstraint * 0.07),
            Flexible(flex: 1, child: _buildStepNoOfTasksOrQuestions(index)),
            SizedBox(height: heightConstraint * 0.03),
          ])),
      Expanded(flex: 2, child: _buildContinueButton(index)),
    ]);
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

  Widget _buildAvatar(int index, constraints) {
    var heightConstraint = constraints.maxHeight;
    if (_dataStore.getStepImage(index) == null) return Container();
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: heightConstraint * 0.05),
        child: LoadImageWithCache(
          imageUrl:
              Endpoints.stepsImageBaseUrl + _dataStore.getStepImage(index)!,
          color: AppColors.main_color,
        ),
      ),
    );
  }

  Widget _buildStepTitle(currentStepNo) {
    var step_title_id = _dataStore.stepList.steps[currentStepNo].name;
    return AutoSizeText(
      "${_technicalNameWithTranslationsStore.getTranslation(step_title_id)}",
      style: Theme.of(context).textTheme.titleMedium;
  }

  Widget _buildStepNoOfTasksOrQuestions(currentStepNo) {
    return Text(
        isQuestionsStep(currentStepNo)
            ? noOfQuestionsString(currentStepNo)
            : noOfTasksString(currentStepNo),
        style: Theme.of(context).textTheme.bodySmall);
  }

  bool isQuestionsStep(currentStepNo) => isFirstStep(currentStepNo);
  bool isFirstStep(currentStepNo) => currentStepNo == 0;

  String noOfTasksString(currentStepNo) {
    int noOfTasks = _dataStore.getNumberOfTasksFromAStep(currentStepNo);
    String str = "$noOfTasks ";
    switch (noOfTasks) {
      case 1:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.task);
        break;
      default:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.tasks);
        break;
    }
    return str;
  }

  String noOfQuestionsString(currentStepNo) {
    int noOfQuestions = _dataStore.getNumberOfQuestionsFromAStep(currentStepNo);
    String str = "$noOfQuestions ";
    switch (noOfQuestions) {
      case 1:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.question);
        break;
      default:
        str += _technicalNameWithTranslationsStore
            .getTranslationByTechnicalName(LangKeys.questions);
        break;
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionsListPage(
                            stepNumber: currentStepNo,
                          )));
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
                Text(
                    _technicalNameWithTranslationsStore
                        .getTranslationByTechnicalName(LangKeys.continueKey),
                    style: Theme.of(context).textTheme.bodySmall),
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
      backgroundColor: MaterialStateProperty.all(
          AppColors.stepSliderContinueButton.withOpacity(0.5)),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => AppColors.green[100]!.withOpacity(0.3)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.buttonRadius),
          side: BorderSide(color: AppColors.main_color),
        ),
      ),
    );
  }

  Widget _buildProgressBar(currentStepNo) {
    return FractionallySizedBox(
      widthFactor: 0.95,
      heightFactor: 0.3,
      child: Container(
        child: Observer(
          builder: (_) => ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.progressBarRadius)),
            child: LinearProgressIndicator(
                value: _dataStore.values![currentStepNo],
                backgroundColor: AppColors.progressBarBackgroundColor,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
          ),
        ),
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
