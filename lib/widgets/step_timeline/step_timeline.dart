import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class StepTimeLine extends StatefulWidget {

  StepTimeLine({Key? key}) : super(key: key);

  @override
  State<StepTimeLine> createState() => _StepTimeLineState();
}

class _StepTimeLineState extends State<StepTimeLine> {
  late DataStore _dataStore;
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Padding(
      padding: Dimens.stepTimelineContainerPadding,
      child: Container(
        width: _getScreenWidth(),
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.stepTimelineContainerColor,
            borderRadius: Dimens.stepTimelineContainerBorderRadius,
            boxShadow: [
              BoxShadow(
                  color: AppColors.stepTimelineContainerShadowColor,
                  blurRadius: 0.3,
                  offset: Offset(0, 2))
            ]),
        child: _buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return FixedTimeline.tileBuilder(
      direction: Axis.horizontal,
      builder: TimelineTileBuilder(
        itemCount: _dataStore.getAllSteps.length,
        itemExtent: (_getScreenWidth() - 50) / _dataStore.getAllSteps.length,
        indicatorBuilder: (context, index) =>
            _buildIndicator(index),
        startConnectorBuilder: (context, index) => _buildStartConnector(index),
        endConnectorBuilder: (context, index) => _buildEndConnector(index),
      ),
    );
  }

  Widget _buildIndicator(index) {
    if (_isCurrentStep(index)) {
      return _buildCurrent(index);
    }
    if (_isPendingStep(index)) {
      return _buildPendingIndicator();
    }

    if (_isDoneStep(index)) {
      return _buildDoneIndicator();
    }
    return _buildNotStartedIndicator();
  }

  Widget _buildCurrent(index) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: (_isNotStartedStep(index))
                      ? AppColors.stepTimelineNotStartedNodeColor
                      : AppColors.main_color,
                  width: 4),
            ),
            child: Container(
                padding: Dimens.stepTimelineCurrentStepOuterCirclePadding,
                child: Container(
                    padding: Dimens.stepTimelineCurrentStepInnerCirclePadding,
                    decoration: BoxDecoration(
                      color: _colorInnerIndicator(index),
                      shape: BoxShape.circle,
                    )))));
  }

  Color _colorInnerIndicator(index) {
    if (_isPendingStep(index)) {
      return AppColors.stepTimelinePendingColor;
    }
    if (_isDoneStep(index)) {
      return AppColors.main_color;
    }
    return AppColors.stepTimelineNotStartedNodeColor;
  }

  Widget _buildDoneIndicator() {
    return const DotIndicator(size: 10, color: AppColors.main_color);
  }

  Widget _buildNotStartedIndicator() {
    return DotIndicator(
      size: 10,
      color: AppColors.stepTimelineNotStartedNodeColor,
    );
  }

  Widget _buildPendingIndicator() {
    return DotIndicator(
      size: 13,
      color: AppColors.stepTimelinePendingColor,
    );
  }

  BoxDecoration _buildStartGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.step_timeline_connector_gradient[100]!,
          AppColors.step_timeline_connector_gradient[200]!,
        ],
      ),
    );
  }

  BoxDecoration _buildEndGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.step_timeline_connector_gradient[50]!,
          AppColors.step_timeline_connector_gradient[100]!
        ],
      ),
    );
  }

  Widget _buildPendingStartConnectorGradient() {
    return DecoratedLineConnector(
      thickness: Dimens.pendingStartConnectorGradientThickness,
      decoration: _buildStartGradient(),
      endIndent: Dimens.pendingStartConnectorGradientEndIndent,
    );
  }

  Widget _buildPendingEndConnectorGradient() {
    return DecoratedLineConnector(
        thickness: Dimens.pendingEndConnectorGradientThickness,
        decoration: _buildEndGradient(),
        indent: Dimens.pendingEndConnectorGradientIndent);
  }

  Widget _buildNotStartedStartConnector() {
    return DashedLineConnector(
        thickness: Dimens.notStartedStartConnectorThickness,
        color: AppColors.stepTimelineNotStartedConnectorColor,
        gap: Dimens.notStartedStartConnectorGap,
        endIndent: Dimens.notStartedStartConnectorEndIndent);
  }

  Widget _buildNotStartedEndConnector() {
    return DashedLineConnector(
        thickness: Dimens.notStartedEndConnectorThickness,
        color: AppColors.stepTimelineNotStartedConnectorColor,
        gap: Dimens.notStartedEndConnectorGap,
        indent: Dimens.notStartedEndConnectorIndent);
  }

  Widget _buildDoneStartConnector() {
    return SolidLineConnector(
        thickness: 3, color: AppColors.main_color, endIndent: 10);
  }

  Widget _buildDoneEndConnector() {
    return SolidLineConnector(
      thickness: Dimens.doneEndConnectorThickness,
      color: AppColors.main_color,
      indent: Dimens.doneEndConnectorIndent,
    );
  }

  Widget? _buildStartConnector(index) {
    if(_isFirstStep(index)){
      return null;
    }
    if (_isPendingStep(index)) {
      return _buildPendingStartConnectorGradient();
    }
    if (_isNotStartedStep(index)) {
      return _buildNotStartedStartConnector();
    }
    return _buildDoneStartConnector();
  }

  Widget? _buildEndConnector(int index) {
    if(_isLastStep(index)){
      return null;
    }
    if (_isPendingStep(index)) {
      return _buildNotStartedEndConnector();
    }
    if (index == _dataStore.getIndexOfStep(_appSettingsStore.currentStepId)) {
      return _buildPendingEndConnectorGradient();
    }
    if (_isNotStartedStep(index)) {
      return _buildNotStartedEndConnector();
    }
    return _buildDoneEndConnector();
  }

  //logic methods : ..............................................................
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  _isLastStep(index) {
    return index == _dataStore.getAllSteps.length - 1;
  }

  _isFirstStep(index) {
    return _dataStore.isFirstStep(_dataStore.getStepByIndex(index).id);
  }

  _isCurrentStep(index) {
    return index == _dataStore.getIndexOfStep(_appSettingsStore.currentStepId);
  }

  _isPendingStep(index) {
    return _dataStore.stepIsPending(_dataStore.getStepByIndex(index).id);
  }

  _isDoneStep(index) {
    return _dataStore.stepIsDone(_dataStore.getStepByIndex(index).id);
  }

  _isNotStartedStep(index) {
    return _dataStore.stepIsNotStarted(_dataStore.getStepByIndex(index).id);
  }
}
