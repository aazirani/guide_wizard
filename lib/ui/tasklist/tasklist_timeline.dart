import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import '../../widgets/diamond_indicator.dart';
import '../../constants/colors.dart';
import '../../models/task/task.dart';
import '../../utils/enums/enum.dart';

class TaskListTimeLine extends StatefulWidget {
  final List<Task> tasks;
  TaskListTimeLine({
    Key? key,
    required this.tasks,
  }) : super(key: key);

  @override
  State<TaskListTimeLine> createState() => _TaskListTimeLineState();
}

class _TaskListTimeLineState extends State<TaskListTimeLine> {
  @override
  Widget build(BuildContext context) {
    // final stepStore = Provider.of<StepStore>(context);
    return _buildTimelineContainer();
  }

  Widget _buildTimelineContainer() {
    return Container(
      padding: EdgeInsets.only(),
      height: _getScreenHeight(),
      width: double.infinity,
      child: Align(
        alignment: Alignment.topLeft,
        child: _buildTimeline(),
      ),
    );
  }

  Widget _buildTimeline() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            direction: Axis.vertical,
            color: Colors.blue,
            nodePosition: 0.05,
          ),
          builder: TimelineTileBuilder(
            itemCount: 4,
            itemExtent: 115,
            contentsBuilder: (context, index) => _buildContents(index),
            indicatorBuilder: (context, index) => _buildIndicator(),
            startConnectorBuilder: (context, index) => _buildConnector(),
            endConnectorBuilder: (context, index) => _buildConnector(),
          )),
    );
  }

  Widget _buildIndicator() {
    return Container(
        color: Colors.transparent,
        width: 8,
        height: 8,
        child: DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: Color.fromARGB(255, 115, 213, 172));
  }

  Widget _buildContents(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          width: _getScreenWidth() / 1.23,
          height: 100,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 243, 243),
            border: Border(
              left: BorderSide(
                  width: 25,
                  color: Color.fromARGB(255, 47, 205, 144).withOpacity(0.3)),
            ),
          ),
          child: _buildInsideElements(index),
        ),
      ),
    );
  }

  Widget _buildInsideElements(index) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContentTitle(index),
              _buildContentDeadline(index),
            ],
          ),
          Spacer(),
          _buildContentMoreIcon(),
        ],
      ),
    );
  }

  Widget _buildContentTitle(index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text("${widget.tasks[index].title}",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: 16,
          )),
    );
  }

  Widget _buildContentDeadline(index) {
    return Container(
        padding: EdgeInsets.only(top: 20),
        width: 80,
        height: 40,
        child: (_deadLineAvailable(index))
            ? _buildDeadlineContainer(index)
            : null);
  }

  Widget _buildDeadlineContainer(index) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                width: 2,
                color: (_taskDone(index)) ? Color.fromARGB(255, 51, 181, 129) : Color.fromARGB(255, 169, 25, 12))),
        child: Center(child: Text("Deadline", style: TextStyle(fontSize: 13))));
  }

  Widget _buildContentMoreIcon() {
    return Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.more_vert, color: AppColors.main_color));
  }

  //general methods ............................................................
  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  bool _deadLineAvailable(index) {
    switch (widget.tasks[index].deadline) {
      case null:
        return false;
    }
    return true;
  }

  bool _taskDone(index) {
    switch (widget.tasks[index].status) {
      case TaskStatus.Done:
        return true;
      case TaskStatus.notDone:
        return false;
    }
  }
}
