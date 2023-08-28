import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/tasklist/tasklist_timeline.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/scrolling_overflow_text.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  AppStep step;
  TaskList({Key? key, required this.step}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // stores:--------------------------------------------------------------------
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

  var progressBarSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.main_color,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  //appBar methods .............................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.main_color,
        toolbarHeight: Dimens.appBar["toolbarHeight"],
        titleSpacing: Dimens.appBar["titleSpacing"],
        title: ScrollingOverflowText(
          _technicalNameWithTranslationsStore.getTranslation(widget.step.name)!,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white),
          overflowRatio: 0.77,
        ),
        leading: Padding(
          padding: Dimens.back_button,
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
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
                child: Text(
                    "${widget.step.tasks.length} ${_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.tasks)}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.white))),
            SizedBox(height: 5),
            _buildProgressBar(),
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
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: widget.step.tasks.length,
                itemBuilder: (context, index) {
                  return TaskListTimeLine(step: widget.step, index: index, task: widget.step.tasks.elementAt(index));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 20,
      width: _getScreenWidth() / 1.19,
      child: Padding(
          padding: Dimens.taskListProgressBarPadding,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.taskListProgressBarRadius)),
            child: Observer(
              builder: (_) => LinearProgressIndicator(
                  value: calculateDoneRatio(),
                  backgroundColor: AppColors.white,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
            ),
          )),
    );
  }

  double calculateDoneRatio() {
    int noOfDoneTasksInThisStep = _dataStore.getDoneTasks(widget.step.id).length;
    int noOfAllTasksInThisStep = widget.step.tasks.length;
    return noOfAllTasksInThisStep == 0
        ? 0.0
        : noOfDoneTasksInThisStep / noOfAllTasksInThisStep;
  }

  // general methods ...........................................................
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
