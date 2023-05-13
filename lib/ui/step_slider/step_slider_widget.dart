import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/question/questions_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/questions/questions_list_page.dart';
import 'package:boilerplate/utils/enums/enum.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/task_list/task_list_store.dart';
import 'package:boilerplate/ui/tasklist/tasklist.dart';
import 'package:boilerplate/stores/step/steps_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/models/step/step_list.dart';

import '../../stores/task/tasks_store.dart';

class StepSliderWidget extends StatefulWidget {
  StepList stepList;
  StepSliderWidget({Key? key, required this.stepList}) : super(key: key);

  @override
  State<StepSliderWidget> createState() => _StepSliderWidgetState();
}

class _StepSliderWidgetState extends State<StepSliderWidget> {
  late StepStore _stepStore;
  late StepsStore _stepsStore;
  late TaskListStore _taskListStore;
  late TasksStore _tasksStore;
  late QuestionsStore _questionsStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepStore = Provider.of<StepStore>(context);
    _stepsStore = Provider.of<StepsStore>(context);
    _taskListStore = Provider.of<TaskListStore>(context);
    _tasksStore = Provider.of<TasksStore>(context);
    _questionsStore = Provider.of<QuestionsStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
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
          onPageChanged: (index, reason) {
            _stepStore.increment(index);
          },
          height: _getScreenHeight() / 4,
          enlargeCenterPage: false,
          enableInfiniteScroll: false),
      items: List<int>.generate(
          _stepsStore.stepList.steps.length, (index) => index).map((index) {
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
            _buildAvatar(),
            _buildContent(index),
          ],
        ));
  }

  BoxBorder _buildSliderBorder(index) {
    switch (_getStepStatus(index)) {
      case StepStatus.isDone:
        return _buildDoneBorder();
      case StepStatus.isPending:
        return _buildPendingBorder();
      case StepStatus.notStarted:
        return _buildNotStartedBorder();
    }
  }

  Color _buildSliderColor(index) {
    switch (_getStepStatus(index)) {
      case StepStatus.isPending:
      case StepStatus.isDone:
        return AppColors.stepSliderAvailableColor;
      default:
        return AppColors.stepSliderUnavailableColor;
    }
  }

  Widget _buildAvatar() {
    return Stack(children: [
      _buildBoyAvatar(),
      _buildGirlAvatar(),
    ]);
  }

  Widget _buildBoyAvatar() {
    return Padding(
      padding: Dimens.avatarBoyPadding,
      child: Image.asset("assets/images/avatar_boy.png", fit: BoxFit.contain),
    );
  }

  Widget _buildGirlAvatar() {
    return Padding(
        padding: Dimens.avatarGirlPadding,
        child: Image.asset("assets/images/avatar_girl.png", fit: BoxFit.cover));
  }

  Widget _buildContent(currentStepNo) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10),
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
    var step_title_id = _stepsStore.stepList.steps[currentStepNo].name.id;
    return Text(
      // "${_stepsStore.stepList.steps[currentStepNo].name.technical_name.toString()}",
      "${_technicalNameWithTranslationsStore.getTechnicalNames(step_title_id)}",
      style: TextStyle(fontSize: 17, color: AppColors.main_color),
    );
  }

  Widget _buildStepNoOfTasks(currentStepNo) {
    return Text(
        "${_stepsStore.stepList.steps[currentStepNo].numTasks}" +
            " " +
            AppLocalizations.of(context).translate('tasks'),
        style: TextStyle(fontSize: 15, color: AppColors.main_color));
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
            // _taskListStore.getTaskList(_stepStore.currentStep);
            _tasksStore.getTasks(_stepStore.currentStep);
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
              style: TextStyle(fontSize: 12, color: AppColors.main_color)),
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
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: AppColors.main_color))));
  }

  Widget _buildProgressBar(double percentage) {
    return Container(
      height: 20,
      child: Padding(
          padding: EdgeInsets.only(right: 10, top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
    return Border.all(width: 4, color: AppColors.main_color);
  }

  Border _buildDoneBorder() {
    return Border.all(width: 1, color: AppColors.main_color);
  }

  Border _buildNotStartedBorder() {
    return Border.all(width: 2, color: AppColors.stepSliderUnavailableBorder);
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  StepStatus _getStepStatus(index) {
    if (_stepStore.pending == index) {
      return StepStatus.isPending;
    } else if (index < _stepStore.pending) {
      return StepStatus.isDone;
    }
    return StepStatus.notStarted;
  }
}
