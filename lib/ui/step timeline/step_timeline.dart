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
            color: Color.fromARGB(255, 239, 237, 237),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, blurRadius: 0.3, offset: Offset(0, 2))
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
        // contentsBuilder: (context, index) => _buildContents(),
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
    return const DotIndicator(
      size: 10,
      color: Colors.grey,
    );
  }

  Widget _buildPendingIndicator() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.main_color, width: 4),
          ),
          child: Container(
              padding: const EdgeInsets.all(2),
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 115, 213, 172),
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
          const Color.fromARGB(159, 77, 172, 180),
          Color.fromARGB(255, 124, 222, 194)
        ],
      ),
    );
  }

  BoxDecoration _buildEndGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [AppColors.main_color, Color.fromARGB(159, 77, 172, 180)],
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
    return const DashedLineConnector(
        thickness: 3, color: Colors.grey, gap: 2, endIndent: 10);
  }

  Widget _buildNotStartedEndConnector() {
    return const DashedLineConnector(
        thickness: 3, color: Colors.grey, gap: 2, indent: 10);
  }

  Widget? _buildStartConnector(index) {
    return (stepNo - index == stepNo)
        ? null
        : (index == widget.pending)
            ? _buildPendingStartConnectorGradient()
            : (index > widget.pending)
                ? _buildNotStartedStartConnector()
                : const SolidLineConnector(
                    thickness: 3, color: AppColors.main_color, endIndent: 10);
  }

  Widget? _buildEndConnector(index) {
    return (index == stepNo)
        ? null
        : (index == widget.pending)
            ? _buildNotStartedEndConnector()
            : (index == widget.pending - 1)
                ? _buildPendingEndConnectorGradient()
                : (index > widget.pending)
                    ? _buildNotStartedEndConnector()
                    : const SolidLineConnector(
                        thickness: 3, color: AppColors.main_color, indent: 10);
  }

  double _getScreenWidth() => MediaQuery.of(context).size.width;

}
