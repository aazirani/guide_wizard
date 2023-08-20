import 'package:flutter/material.dart';
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
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Container(
      padding: Dimens.timelineContainerPadding,
      height: _getScreenHeight() / 2.8,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topLeft,
        child: _buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return Align(
      alignment: Alignment.topLeft,
      child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            direction: Axis.vertical,
            nodePosition: Dimens.timelineNodePosition,
          ),
          builder: TimelineTileBuilder(
            itemCount: _dataStore.getAllSteps().length == 0
                ? 0
                : _dataStore.getStepById(_appSettingsStore.currentStepId).tasks.length,
            itemExtent: 70,
            contentsBuilder: (context, index) =>
                _buildContents(index),
            indicatorBuilder: (context, index) => _buildIndicator(index),
            startConnectorBuilder: (context, index) => index == 0 && _dataStore.getStepByIndex(index).id == _dataStore.getAllSteps().elementAt(1).id
                ? Container()
                : _buildConnector(),
            endConnectorBuilder: (context, index) => _dataStore.getStepByIndex(index).id == _dataStore.getAllSteps().last.id
                ? Container()
                : _buildConnector(),
          )),
    );
  }

  bool isTaskDone(index){
    return _dataStore.getAllTasks().elementAt(index).isDone;
  }

  Widget _buildIndicator(taskIndex) {
    return Container(
        color: AppColors.transparent,
        width: Dimens.timelineIndicatorDimens,
        height: Dimens.timelineIndicatorDimens,
        child: DiamondIndicator(fill: isTaskDone(taskIndex))
    );
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical,
        color: AppColors.timelineCompressedConnectorColor);
  }

  Widget _buildContents(index) {
    return Container(
      width: _getScreenWidth() / 1.23,
      height: _getScreenHeight() / 15,
      margin: Dimens.contentLeftMargin,
      padding: Dimens.compressedTaskListContentPadding,
      decoration: BoxDecoration(
        color: AppColors.timelineCompressedContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
      ),
      child: Row(
        children: [
          _buildContentTitle(index),
        ],
      ),
    );
  }

  Widget _buildContentTitle(index) {
    return Flexible(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "${_technicalNameWithTranslationsStore.getTranslation(_dataStore.getStepById(_appSettingsStore.currentStepId).tasks.elementAt(index).text)}",
            style: TextStyle(
              color: AppColors.main_color,
              fontSize: Dimens.taskListTimeLineContentTitle,
            )),
      ),
    );
  }

  Widget _buildContentMoreButton() {
    return Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.more_vert, color: AppColors.main_color));
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
