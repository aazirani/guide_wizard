import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:boilerplate/stores/data/data_store.dart';

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
    return Observer(
      builder: (_) => Align(
        alignment: Alignment.topLeft,
        child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              direction: Axis.vertical,
              nodePosition: Dimens.timelineNodePosition,
            ),
            builder: TimelineTileBuilder(
              itemCount: _dataStore.getNumberOfSteps() == 0
                  ? 0
                  : _dataStore.getNumberOfTasksFromAStep((_stepStore.currentStep) - 1),
              itemExtent: 70,
              contentsBuilder: (context, index) =>
                  _buildContents(index, _stepStore),
              indicatorBuilder: (context, index) => _buildIndicator(),
              startConnectorBuilder: (context, index) => _buildConnector(),
              endConnectorBuilder: (context, index) => _buildConnector(),
            )),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical,
        color: AppColors.timelineCompressedConnectorColor);
  }

  Widget _buildContents(index, stepStore) {
    return Container(
      width: _getScreenWidth() / 1.23,
      height: 60,
      // margin: EdgeInsets.only(left: 20),
      margin: Dimens.contentLeftMargin,
      decoration: BoxDecoration(
          color: AppColors.timelineCompressedContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(Dimens.contentRadius)),
          boxShadow: [
            BoxShadow(
              color: AppColors.timelineCompressedContainerShadowColor,
              blurRadius: 2,
              offset: Offset(1, 2),
              spreadRadius: 1,
            )
          ]),
      child: _buildContentElements(index, stepStore),
    );
  }

  Widget _buildContentElements(index, stepStore) {
    return Padding(
      padding: Dimens.compressedTaskListContentPadding,
      child: Row(
        children: [
          _buildContentTitle(index, stepStore),
          Spacer(),
          _buildContentMoreButton(),
        ],
      ),
    );
  }

  Widget _buildContentTitle(index, stepStore) {
    var stepTitleId = _dataStore.getTaskTitleId(stepStore.currentStep - 1, index);
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          "${_technicalNameWithTranslationsStore.getTranslation(stepTitleId)}",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: 16,
          )),
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
