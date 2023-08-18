import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/step/step_list.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/diamond_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class CompressedTasklistTimeline extends StatefulWidget {
  StepList stepList;
  CompressedTasklistTimeline({Key? key, required this.stepList})
      : super(key: key);

  @override
  State<CompressedTasklistTimeline> createState() =>
      _CompressedTasklistTimelineState();
}

class _CompressedTasklistTimelineState
    extends State<CompressedTasklistTimeline> {
  late DataStore _dataStore;
  late StepStore _stepStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  // Getters ............................................................
  get _getScreenHeight => MediaQuery.of(context).size.height;
  get _getScreenWidth => MediaQuery.of(context).size.width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepStore = Provider.of<StepStore>(context);
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimeline();
  }

  Widget _buildTimeline() {
    return Observer(
      builder: (_) => RawScrollbar(
        child: Timeline.tileBuilder(
          shrinkWrap: true,
          // physics: AlwaysScrollableScrollPhysics(),
          theme: TimelineThemeData(
            direction: Axis.vertical,
            nodePosition: Dimens.timelineNodePosition,
          ),
          builder: TimelineTileBuilder(
            itemCount: _dataStore.getNumberOfSteps() == 0
                ? 0
                : _dataStore.getNumberOfTasksFromAStep((_stepStore.currentStep) - 1),
            itemExtent: Dimens.compressedTaskListTimeLineItemExtend,
            contentsBuilder: (context, index) => _buildContents(index, _stepStore),
            indicatorBuilder: (context, index) => _buildIndicator(index, _stepStore.currentStep),
            startConnectorBuilder: (context, index) => index == 0 && (_stepStore.currentStep) - 1 == 1
                ? Container()
                : _buildConnector(),
            endConnectorBuilder: (context, index) => (_stepStore.currentStep)  == _dataStore.getNumberOfSteps()
                ? Container()
                : _buildConnector(),
          ),
        ),
      ),
    );
  }

  bool isTaskDone(taskIndex, currentStepIndex){
    return _dataStore.allTasks
        .tasks.where((element) => element.step_id == _dataStore.stepList.steps[currentStepIndex - 1].id).toList()[taskIndex].isDone;
  }

  Widget _buildIndicator(taskIndex, currentStepIndex) {
    return Container(
        color: AppColors.transparent,
        width: Dimens.timelineIndicatorDimens,
        height: Dimens.timelineIndicatorDimens,
        child: DiamondIndicator(fill: isTaskDone(taskIndex, currentStepIndex),));
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical,
        color: AppColors.timelineCompressedConnectorColor);
  }

  Widget _buildContents(index, stepStore) {
    return Container(
      margin: Dimens.contentLeftMargin,
      padding: Dimens.compressedTaskListContentPadding,
      decoration: BoxDecoration(
        color: AppColors.timelineCompressedContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
      ),
      child: _buildContentTitle(index, stepStore),
    );
  }

  Widget _buildContentTitle(index, stepStore) {
    var stepTitleId = _dataStore.getTaskTitleId(stepStore.currentStep - 1, index);
    return Row(
      children: [
        Flexible(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${_technicalNameWithTranslationsStore.getTranslation(stepTitleId)}",
              style: TextStyle(
                color: AppColors.main_color,
                fontSize: Dimens.taskListTimeLineContentTitle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
