import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../constants/colors.dart';

class StepTimeLine extends StatefulWidget {
  const StepTimeLine({Key? key}) : super(key: key);

  @override
  State<StepTimeLine> createState() => _StepTimeLineState();
}

class _StepTimeLineState extends State<StepTimeLine> {

  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: _getScreenWidth() / 1.2,
        height: _getScreenHeight() / 18,
        decoration: BoxDecoration(
          color: Color.fromARGB(207, 245, 249, 248).withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                spreadRadius: 4,
                blurRadius: 4,
                color: Color.fromARGB(116, 139, 154, 150).withOpacity(0.2),
                offset: Offset(0, 5)),
          ],
        ),
        child: Align(
            alignment: Alignment.center,
            // child: Text("hi")
            child: FixedTimeline.tileBuilder(
              direction: Axis.horizontal,
              builder: TimelineTileBuilder.connectedFromStyle(
                connectionDirection: ConnectionDirection.before,
                connectorStyleBuilder: (context, index) {
                  return (index == 1)
                      ? ConnectorStyle.dashedLine
                      : ConnectorStyle.solidLine;
                },
                indicatorStyleBuilder: (context, index) => IndicatorStyle.outlined,
                itemExtent: (_getScreenWidth() / 1.2) / 4,
                itemCount: 4,
              ),
            ))
        // child: FixedTimeline(children: [TimelineNode.simple()])),
        );
  }

  BoxDecoration _buildStartGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color.fromARGB(159, 25, 156, 196), Colors.green.shade600],
      ),
    );
  }

  BoxDecoration _buildEndGradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [AppColors.main_color, Color.fromARGB(159, 25, 156, 196)],
      ),
    );
  }

  Widget _buildStartConnector() {
    return DecoratedLineConnector(
      thickness: 6,
      direction: Axis.horizontal,
      decoration: _buildStartGradient(),
    );
  }

  Widget _buildEndConnector() {
    return DecoratedLineConnector(
      thickness: 6,
      direction: Axis.horizontal,
      decoration: _buildEndGradient(),
    );
  }

  Widget _buildIndicator() {
    return DotIndicator(color: AppColors.main_color);
  }

  Widget _buildNode(int index) {
    return TimelineNode(
      indicator: _buildIndicator(),
      startConnector: (index == 0) ? null : _buildStartConnector(),
      endConnector: (index == 3) ? null : _buildEndConnector(),
    );
  }
}