import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:boilerplate/models/step/step.dart' as s;
import 'package:boilerplate/constants/colors.dart';

class StepTimeLine extends StatefulWidget {
  final List<s.Step> steps;
  final int pending;
  final int stepNo;
  StepTimeLine(
      {Key? key,
      required this.pending,
      required this.stepNo,
      required this.steps})
      : super(key: key);

  @override
  State<StepTimeLine> createState() => _StepTimeLineState();
}

class _StepTimeLineState extends State<StepTimeLine> {
  int index = 3;
  late int pending = widget.pending;
  late int stepNo = widget.stepNo;

  @override
  Widget build(BuildContext context) {
    print(widget.pending);
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        width: _getScreenWidth(),
        height: 40,
        decoration: BoxDecoration(
            color: AppColors.stepTimelineContainerColor,
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
        itemCount: 4,
        itemExtent: 90,
        indicatorBuilder: (context, index) => _buildIndicator(index),
        startConnectorBuilder: (context, index) => _buildStartConnector(index),
        endConnectorBuilder: (context, index) => _buildEndConnector(index),
      ),
    );
  }

  Widget _buildIndicator(index) {
    return (index == widget.pending)
        ? _buildPendingIndicator()
        : (index < widget.pending)
            ? _buildDoneIndicator()
            : _buildNotStartedIndicator();
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
    return Center(
      child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.main_color, width: 4),
          ),
          child: Container(
              padding: const EdgeInsets.all(2),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.stepTimelinePendingColor,
                    shape: BoxShape.circle,
                  )))),
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
      thickness: 3,
      decoration: _buildStartGradient(),
      endIndent: 10,
    );
  }

  Widget _buildPendingEndConnectorGradient() {
    return DecoratedLineConnector(
        thickness: 3, decoration: _buildEndGradient(), indent: 10);
  }

  Widget _buildNotStartedStartConnector() {
    return DashedLineConnector(
        thickness: 3,
        color: AppColors.stepTimelineNotStartedConnectorColor,
        gap: 2,
        endIndent: 10);
  }

  Widget _buildNotStartedEndConnector() {
    return DashedLineConnector(
        thickness: 3,
        color: AppColors.stepTimelineNotStartedConnectorColor,
        gap: 2,
        indent: 10);
  }

  Widget? _buildStartConnector(index) {
    if (index != 0 && index == widget.pending)
      return _buildPendingStartConnectorGradient();
    else if (index != 0 && index > widget.pending)
      return _buildNotStartedStartConnector();
    else if (index != 0 && index < widget.pending)
      return SolidLineConnector(
          thickness: 3, color: AppColors.main_color, endIndent: 10);

    return null;
  }


  // Widget? _buildEndConnector(index) {
  //   if (index != stepNo && index == widget.pending)
  //     return _buildNotStartedEndConnector();
  //   else if (index != stepNo && index == widget.pending - 1)
  //     return _buildPendingEndConnectorGradient();
  //   else if (index != stepNo && index > widget.pending)
  //     return _buildNotStartedEndConnector();
  //   else if (index != stepNo && index < widget.pending)
  //     return SolidLineConnector(
  //       thickness: 3,
  //       color: AppColors.main_color,
  //       indent: 10,
  //     );
  //   return null;
  // }

  Widget? _buildEndConnector(int index) {
  if (index == stepNo) {
    return null;
  }
  if (index == widget.pending) {
    return _buildNotStartedEndConnector();
  }
  if (index == widget.pending - 1) {
    return _buildPendingEndConnectorGradient();
  }
  if (index > widget.pending) {
    return _buildNotStartedEndConnector();
  }
  return SolidLineConnector(
    thickness: 3,
    color: AppColors.main_color,
    indent: 10,
  );
}

  double _getScreenWidth() => MediaQuery.of(context).size.width;
}
