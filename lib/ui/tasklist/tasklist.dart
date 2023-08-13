import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/tasklist/tasklist_timeline.dart';
import 'package:guide_wizard/utils/locale/app_localization.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/scrolling_overflow_text.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  int currentStepNo;
  TaskList({Key? key, required this.currentStepNo}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late StepStore _stepStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  var progressBarSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _changeStepAndNavigateHome(),
      child: Scaffold(
          backgroundColor: AppColors.main_color,
          appBar: _buildAppBar(),
          body: _buildBody()),
    );
  }

  //appBar methods .............................................................
  PreferredSizeWidget _buildAppBar() {
    //text id of the step we want to find the title of
    int step_title_id = _dataStore.getStepTitleId(widget.currentStepNo);
    return AppBar(
        backgroundColor: AppColors.main_color,
        toolbarHeight: Dimens.appBar["toolbarHeight"],
        titleSpacing: Dimens.appBar["titleSpacing"],
        title: ScrollingOverflowText(
          _technicalNameWithTranslationsStore.getTranslation(step_title_id)!,
          style: TextStyle(
              color: AppColors.white,
              fontSize: Dimens.taskTitleFont,
              fontWeight: FontWeight.bold),
          overflowRatio: 0.77,
        ),
        leading: Padding(
          padding: Dimens.back_button,
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                _changeStepAndNavigateHome();
              },
              color: AppColors.white),
        ));
  }

  // body methods ..............................................................

  Widget _buildBody() {
    return Stack(children: [
      MeasureSize(
          onChange: (Size size) {
            setState(() {
              progressBarSize = size;
            });
          },
          child: _buildTaskProgressBar()),
      _buildExpandableTaskTimeline(),
    ]);
  }

  Widget _buildTaskProgressBar() {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: FittedBox(
          child: Padding(
        padding: Dimens.taskProgressBarPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: Dimens.numberOfTasksPadding,
                child: Observer(
                  builder: (_) => Text(
                      "${_dataStore.getNumberOfTaskListTasks()} ${AppLocalizations.of(context).translate(LangKeys.tasks)}",
                      style: TextStyle(color: AppColors.white)),
                )),
            SizedBox(height: 5),
            Observer(builder: (_) => _buildProgressBar()),
          ],
        ),
      )),
    );
  }

  Widget _buildExpandableTaskTimeline() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: _getProgressBarHeight(),
        maxChildSize: 1,
        minChildSize: _getProgressBarHeight(),
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: AppColors.main_color,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(Dimens.draggableScrollableSheetRadius),
                    topRight:
                        Radius.circular(Dimens.draggableScrollableSheetRadius),
                  ),
                  color: AppColors.white),
              child: Observer(
                builder: (_) => ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  itemCount: _dataStore.getNumberOfTaskListTasks(),
                  itemBuilder: (context, i) {
                    return TaskListTimeLine(taskNumber: i);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    var noOfDoneTasksInThisStep =
        _dataStore.getNumberofDoneTasks(_stepStore.currentStep - 1);
    var noOfAllTasksInThisStep =
        _dataStore.getNumberOfTasksFromAStep(_stepStore.currentStep - 1);
    var percentage = noOfAllTasksInThisStep == 0
        ? 0.0
        : noOfDoneTasksInThisStep / noOfAllTasksInThisStep;
    return Container(
      height: 20,
      width: _getScreenWidth() / 1.19,
      child: Padding(
          padding: Dimens.taskListProgressBarPadding,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.taskListProgressBarRadius)),
            child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.white,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
          )),
    );
  }

  // general methods ...........................................................
  _changeStepAndNavigateHome() {
    if (_dataStore.values![_appSettingsStore.currentStepNumber] == 1) {
      _appSettingsStore.currentStepNumber += 1;
    }
    return true;
  }

  double _getProgressBarHeight() {
    return (_getScreenHeight() -
            (progressBarSize.height + _getStatusBarHeight())) /
        _getScreenHeight();
  }

  double _getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  double _getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _getStatusBarHeight() {
    return MediaQuery.of(context).viewPadding.top;
  }
}
