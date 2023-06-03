import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/stores/current_step/current_step_store.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/constants/dimens.dart';

class StepTimeLine extends StatefulWidget {
  final int stepNo;
  StepTimeLine(
      {Key? key,
      required this.stepNo})
      : super(key: key);

  @override
  State<StepTimeLine> createState() => _StepTimeLineState();
}

class _StepTimeLineState extends State<StepTimeLine> {
  late StepStore _stepStore;
  late CurrentStepStore _currentStepStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepStore = Provider.of<StepStore>(context);
    _currentStepStore = Provider.of<CurrentStepStore>(context);
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
        child:_buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return FixedTimeline.tileBuilder(
      direction: Axis.horizontal,
      builder: TimelineTileBuilder(
        itemCount: _currentStepStore.stepsCount,
        itemExtent: (_getScreenWidth() - 50) / 4,
        indicatorBuilder: (context, index) =>
            Observer(builder: (_) => _buildIndicator(index)),
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
        thickness: Dimens.pendingEndConnectorGradientThickness, decoration: _buildEndGradient(), indent: Dimens.pendingEndConnectorGradientIndent);
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
    if (index == 0) {
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
    if (index == widget.stepNo - 1) {
      return null;
    }
    if (_isPendingStep(index)) {
      return _buildNotStartedEndConnector();
    }
    if (index == _currentStepStore.currentStepNumber - 1) {
      return _buildPendingEndConnectorGradient();
    }
    if (_isNotStartedStep(index)) {
      return _buildNotStartedEndConnector();
    }
    return _buildDoneEndConnector();
  }

  //logic methods : ..............................................................
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  _isCurrentStep(index) {
    return index == _stepStore.currentStep - 1;
  }

  _isPendingStep(index) {
    return index == _currentStepStore.currentStepNumber;
  }

  _isDoneStep(index) {
    return index < _currentStepStore.currentStepNumber;
  }

  _isNotStartedStep(index) {
    return index > _currentStepStore.currentStepNumber;
  }
}
