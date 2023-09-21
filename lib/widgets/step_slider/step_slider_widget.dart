import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/questions/questions_list_page.dart';
import 'package:guide_wizard/ui/tasklist/tasklist.dart';
import 'package:guide_wizard/widgets/load_image_with_cache.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class StepSliderWidget extends StatefulWidget {
  StepSliderWidget({Key? key}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
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
          onPageChanged: (index, reason) {
            _appSettingsStore
                .setCurrentStepId(_dataStore.getStepByIndex(index).id);
          },
          height: _getScreenHeight() / 4,
          enlargeCenterPage: true,
          enableInfiniteScroll: false),
      items: List<int>.generate(_dataStore.getAllSteps.length, (index) => index)
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
      return Observer(
        builder: (_) => Container(
          alignment: Alignment.topLeft,
          width: _getScreenWidth(),
          margin: Dimens.stepSlider.sliderContainerMargin,
          decoration: BoxDecoration(
            color: _buildSliderColor(index),
            border: _buildSliderBorder(index),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(children: [
            Flexible(
              flex: 80,
              child: Row(children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: heightConstraint *
                                Dimens
                                    .stepSlider.contentHeightPaddingPercentage,
                            left: heightConstraint *
                                Dimens.stepSlider.contentLeftPaddingPercentage,
                            right: heightConstraint *
                                Dimens.stepSlider.contentRightPaddingPercentage,
                            bottom: heightConstraint *
                                Dimens
                                    .stepSlider.contentBottomPaddingPercentage),
                        child: _buildContent(index, constraints))),
                (_dataStore.getStepByIndex(index).image != null)
                    ? Expanded(flex: 1, child: _buildAvatar(index, constraints))
                    : Container(
                        width: heightConstraint *
                            Dimens.stepSlider.emptySpaceHeightPercentage)
              ]),
            ),
            (_dataStore.getStepByIndex(index).tasks.isNotEmpty)
                ? Flexible(flex: 10, child: _buildProgressBar(index))
                : Container(
                    height: heightConstraint *
                        Dimens.stepSlider.emptySpaceHeightPercentage),
          ]),
        ),
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
            SizedBox(
                height: heightConstraint *
                    Dimens.stepSlider.spaceBetweenTitleAndNoOfTasksPercentage),
            Flexible(flex: 1, child: _buildStepNoOfTasksOrQuestions(index)),
            SizedBox(
                height: heightConstraint *
                    Dimens.stepSlider
                        .spaceBetweenNoOfTasksAndContinueButtonPercentage),
          ])),
      Expanded(flex: 2, child: _buildContinueButton(index)),
    ]);
  }

  BoxBorder _buildSliderBorder(index) {
    if (index == _dataStore.getIndexOfStep(_appSettingsStore.currentStepId)) {
      return _buildPendingBorder();
    }
    if (_isStepDone(index)) {
      return _buildDoneBorder();
    }
    return _buildPendingBorder();
  }

  Color _buildSliderColor(index) {
    if (_dataStore.stepIsDone(_dataStore.getStepByIndex(index).id)) {
      return context.doneStepColor;
    }
    return context.unDoneStepColor;
  }

  Widget _buildAvatar(int index, constraints) {
    var heightConstraint = constraints.maxHeight;
    if (_dataStore.getStepByIndex(index).image == null) return Container();
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
            right: heightConstraint *
                Dimens.stepSlider.avatarRightPaddingPercentage),
        child: LoadImageWithCache(
          imageUrl: Endpoints.stepsImageBaseUrl +
              _dataStore.getStepByIndex(index).image!,
          color: context.primaryColor,
        ),
      ),
    );
  }

  Widget _buildStepTitle(index) {
    return AutoSizeText(
      "${_technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepByIndex(index).name)}",
      style: Theme.of(context).textTheme.titleMedium!,
      maxLines: 3,
      softWrap: true,
      wrapWords: true,
      minFontSize: Dimens.stepSlider.minFontSizeForTextOverFlow,
    );
  }

  Widget _buildStepNoOfTasksOrQuestions(index) {
    return Text(
        _dataStore.getStepByIndex(index).tasks.isEmpty
            ? noOfQuestionsString(index)
            : noOfTasksString(index),
        style: Theme.of(context).textTheme.bodySmall!);
  }

  String noOfTasksString(index) {
    int noOfTasks = _dataStore.getStepByIndex(index).tasks.length;
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

  String noOfQuestionsString(index) {
    int noOfQuestions = _dataStore.getStepByIndex(index).questions.length;
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

  Widget _buildContinueButton(index) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 3.5,
        ),
        child: TextButton(
          style: _buildButtonStyle(),
          onPressed: () async {
            if (_dataStore.isFirstStep(_dataStore.getStepByIndex(index).id)) {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionsListPage(
                            stepId: _dataStore.getStepByIndex(index).id,
                          )));
              DataLoadHandler().loadDataAndCheckForUpdate();
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskList(
                            step: _dataStore.getStepByIndex(index),
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
                  style: Theme.of(context).textTheme.bodySmall!,
                ),
                SizedBox(width: 1),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.primaryColor,
                  size: 16,
                )
              ]),
        ),
      ),
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(context.continueButtonColor),
      overlayColor: MaterialStateColor.resolveWith(
          (states) => context.continueOverlayColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.stepSlider.buttonRadius),
            side: BorderSide(color: context.primaryColor)),
      ),
    );
  }

  Widget _buildProgressBar(index) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.3,
      child: Container(
        child: Observer(
          builder: (_) => ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.stepSlider.progressBarRadius)),
            child: LinearProgressIndicator(
                value: _dataStore
                        .getDoneTasks(_dataStore.getStepByIndex(index).id)
                        .length /
                    _dataStore.getStepByIndex(index).tasks.length,
                backgroundColor: context.lightBackgroundColor,
                valueColor: AlwaysStoppedAnimation(context.secondaryColor)),
          ),
        ),
      ),
    );
  }

  Border _buildPendingBorder() {
    return Border.all(
        width: Dimens.stepSlider.pendingSliderBorder,
        color: context.primaryColor);
  }

  Border _buildDoneBorder() {
    return Border.all(
        width: Dimens.stepSlider.doneSliderBorder, color: context.primaryColor);
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  bool _isStepDone(index) {
    return _dataStore.stepIsDone(_dataStore.getStepByIndex(index).id);
  }
}
