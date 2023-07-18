import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/questions/questions_list_page.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/step_slider/progress_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
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
  // ReactionDisposer _reaction;
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late CurrentStepStore _currentStepStore;
  List<double> values = [0, 1, 0.5, 0.2];
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

  ReactionDisposer? _reaction;

  @override
  void initState() {
    super.initState();
    _reaction = reaction((_) => _dataStore.taskList.tasks,
        (_) => _dataStore.completionPercentages);
  }

  @override
  void dispose() {
    _reaction?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   values = _dataStore.fillTheNoOfDoneTasksInEachStepList(values);
    //   print("valuessssssssssssssssssssssssss");
    //   print(values);
    // });
    // _dataStore.fillTheNoOfDoneTasksInEachStepList();
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
    return Padding(
      padding: Dimens.stepAvatar,
      child: Container(
          width: double.maxFinite,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(_dataStore.getStepImage(index))),
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
            _buildProgressBar(currentStepNo),
          ]),
    );
  }

  Widget _buildStepTitle(currentStepNo) {
    var step_title_id = _dataStore.stepList.steps[currentStepNo].name.id;
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
          if (_stepStore.currentStep == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuestionsListPage()));
          } else {
            _dataStore.getTasks(_stepStore.currentStep);
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

  Widget _buildProgressBar(currentStepNo) {
    print("this is the valuessssssssss");
    print(_dataStore.values);
    return Container(
      height: 20,
      child: Observer(
        builder: (_) => Padding(
            padding: Dimens.stepSliderprogressBarPadding,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimens.progressBarRadius)),
              child: LinearProgressIndicator(
                  value: _dataStore.values[currentStepNo],
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
