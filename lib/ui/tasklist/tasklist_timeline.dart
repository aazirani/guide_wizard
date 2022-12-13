import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/utils/enums/enum.dart';

class TaskListTimeLine extends StatefulWidget {
  final List<Task> tasks;
  final int index;
  TaskListTimeLine({Key? key, required this.tasks, required this.index})
      : super(key: key);

  @override
  State<TaskListTimeLine> createState() => _TaskListTimeLineState();
}

class _TaskListTimeLineState extends State<TaskListTimeLine> {
  @override
  Widget build(BuildContext context) {
    return _buildTimeline(widget.index);
  }

  Widget _buildTimeline(index) {
    return TimelineTile(
      nodePosition: 0.05,
      contents: _buildContents(index),
      node: TimelineNode(
        indicator: _buildIndicator(index),
        startConnector: _buildConnector(),
        endConnector: _buildConnector(),
      ),
    );
  }

  Widget _buildIndicator(index) {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: (_taskDone(index))
            ? DiamondIndicator(fill: true)
            : DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: AppColors.tasklistConnectorColor);
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
            color: AppColors.contentColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.purple,
                  spreadRadius: 7,
                  blurRadius: 30,
                  offset: Offset(0, 3),
                  blurStyle: BlurStyle.outer)
            ],
            border: Border(
                left: BorderSide(
              width: 25,
              color: (widget.tasks[index].status == TaskStatus.Done)
                  ? AppColors.contentDoneBorderColor
                  : AppColors.contentUnDoneBorderColor,
            )),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: (_deadLineAvailable(index))
                ? [
                    _buildContentTitle(index),
                    _buildContentDeadline(index),
                  ]
                : [Center(child: _buildContentTitle(index))],
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
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                width: 1,
                color: (_taskDone(index))
                    ? AppColors.deadlineDoneBorderColor
                    : AppColors.deadlineUnDoneBorderColor)),
        child: Center(
            child: Text("Deadline",
                style: TextStyle(
                    fontSize: 13,
                    color: (_taskDone(index)
                        ? AppColors.deadlineTextDoneColor
                        : AppColors.deadlineTextUnDoneColor)))));
  }

  Widget _buildContentMoreIcon() {
    return Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.more_vert, color: AppColors.main_color));
  }

  //general methods ............................................................
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
