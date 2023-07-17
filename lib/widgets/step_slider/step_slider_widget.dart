import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/questions/questions_list_page.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/ui/tasklist/tasklist.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/stores/data/data_store.dart';

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
  late CurrentStepStore _currentStepStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _currentStepStore = Provider.of<CurrentStepStore>(context);
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

  _buildCarouselSlider() {
    return CarouselSlider(
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
              onTap: () {},
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
        padding: Dimens.sliderContainerPadding,
        decoration: BoxDecoration(
          color: _buildSliderColor(index),
          border: _buildSliderBorder(index),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Stack(
          children: [
            _buildAvatar(index),
            _buildContent(index),
          ],
        ));
  }

  BoxBorder _buildSliderBorder(index) {
    if (index < _currentStepStore.currentStepNumber)
      return _buildDoneBorder();
    else if (index == _currentStepStore.currentStepNumber)
      return _buildPendingBorder();
    return _buildNotStartedBorder();
  }

  Color _buildSliderColor(index) {
    if (index <= _currentStepStore.currentStepNumber) {
      return AppColors.stepSliderAvailableColor;
    }
    return AppColors.stepSliderUnavailableColor;
  }

  Widget _buildAvatar(int index) {
    if (_dataStore.getStepImage(index) == null) return SizedBox();
    return Padding(
      padding: Dimens.stepAvatar,
      child: Container(
          width: double.maxFinite,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    Endpoints.stepsImageBaseUrl + _dataStore.getStepImage(index)!)),
          )),
    );
  }

  Widget _buildContent(currentStepNo) {
    return Padding(
      padding: Dimens.sliderContainerContentPadding,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepTitle(currentStepNo),
            SizedBox(height: 10),
            _buildStepNoOfTasks(currentStepNo),
            SizedBox(height: 20),
            _buildContinueButton(currentStepNo),
            SizedBox(height: 10),
            //TODO: get the progress percentage from json
            _buildProgressBar(0.2),
          ]),
    );
  }

  Widget _buildStepTitle(currentStepNo) {
    var step_title_id = _dataStore.stepList.steps[currentStepNo].name;
    return Text(
      "${_technicalNameWithTranslationsStore.getTechnicalNames(step_title_id)}",
      style: TextStyle(
          fontSize: Dimens.stepTitleFont, color: AppColors.main_color),
    );
  }

  Widget _buildStepNoOfTasks(currentStepNo) {
    return Text(
        "${_dataStore.getNumberOfTasksFromAStep(currentStepNo)}" +
            " " +
            AppLocalizations.of(context).translate('tasks'),
        style: TextStyle(
            fontSize: Dimens.numOfTasksFont, color: AppColors.main_color));
  }

  Widget _buildContinueButton(currentStepNo) {
    return Container(
      child: TextButton(
        style: _buildButtonStyle(),
        onPressed: () {
          if (currentStepNo == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuestionsListPage()));
          } else {
            var stepId = _dataStore.getStepId(_stepStore.currentStep - 1);
            _dataStore.getTasks(stepId);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TaskList(
                          currentStepNo: currentStepNo,
                        )));
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(AppLocalizations.of(context).translate("continue"),
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
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ButtonStyle(
        fixedSize: MaterialStateProperty.all(
            Size.fromWidth(MediaQuery.of(context).size.width / 4)),
        backgroundColor: MaterialStateProperty.all(
            AppColors.stepSliderContinueButton.withOpacity(0.5)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.buttonRadius),
                side: BorderSide(color: AppColors.main_color))));
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 20,
      child: Padding(
          padding: Dimens.stepSliderprogressBarPadding,
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.progressBarRadius)),
            child: LinearProgressIndicator(
                // minHeight: 4,
                value: percentage,
                backgroundColor: AppColors.progressBarBackgroundColor,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
          )),
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
