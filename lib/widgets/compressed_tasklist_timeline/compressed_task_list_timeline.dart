import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/diamond_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class CompressedTaskListTimeline extends StatefulWidget {

  CompressedTaskListTimeline({Key? key})
      : super(key: key);

  @override
  State<CompressedTaskListTimeline> createState() =>
      _CompressedTaskListTimelineState();
}

class _CompressedTaskListTimelineState
    extends State<CompressedTaskListTimeline> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  late AppSettingsStore _appSettingsStore;

  // Getters ............................................................
  get _getScreenHeight => MediaQuery.of(context).size.height;
  get _getScreenWidth => MediaQuery.of(context).size.width;

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
    return _buildTimeline();
  }

  Widget _buildTimeline() {
    return Observer(
      builder: (_) => RawScrollbar(
        child: Timeline.tileBuilder(
          shrinkWrap: true,
          theme: TimelineThemeData(
            direction: Axis.vertical,
            nodePosition: Dimens.timelineNodePosition,
          ),
          builder: TimelineTileBuilder(
            itemCount: _dataStore.getAllSteps.length == 0
                ? 0
                : _dataStore.getStepById(_appSettingsStore.currentStepId).tasks.length,
            itemExtent: Dimens.compressedTaskListTimeLineItemExtend,
            contentsBuilder: (context, index) =>
                _buildContents(index),
            indicatorBuilder: (context, index) => _buildIndicator(index),
            startConnectorBuilder: (context, index) => index == 0
                ? Container()
                : _buildConnector(),
            endConnectorBuilder: (context, index) => index == _dataStore.getStepById(_appSettingsStore.currentStepId).tasks.length - 1
                ? Container()
                : _buildConnector(),
          ),
        ),
      ),
    );
  }

  bool isTaskDone(index){
    return _dataStore.getStepById(_appSettingsStore.currentStepId).tasks.elementAt(index).isDone;
  }

  Widget _buildIndicator(taskIndex) {
    return Observer(
      builder: (_) => Container(
          color: AppColors.transparent,
          width: Dimens.timelineIndicatorDimens,
          height: Dimens.timelineIndicatorDimens,
          child: DiamondIndicator(fill: isTaskDone(taskIndex))
      ),
    );
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical,
        color: AppColors.timelineCompressedConnectorColor);
  }

  Widget _buildContents(index) {
    return Container(
      margin: Dimens.contentLeftMargin,
      padding: Dimens.compressedTaskListContentPadding,
      decoration: BoxDecoration(
        color: AppColors.timelineCompressedContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
      ),
      child: _buildContentTitle(index),
    );
  }

  Widget _buildContentTitle(index) {
    return Row(
      children: [
        Flexible(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${_technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepById(_appSettingsStore.currentStepId).tasks.elementAt(index).text)}",
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
