import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/ui/tasks/task_page_text_only.dart';
import 'package:boilerplate/ui/tasks/task_page_with_image.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/models/task/task_list.dart';

class TaskListTimeLine extends StatefulWidget {
  final List<Task> taskList;
  final int index;
  TaskListTimeLine({Key? key, required this.taskList, required this.index})
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
      padding: Dimens.contentContainerPadding,
      child: ClipRRect(
        borderRadius: Dimens.contentContainerBorderRadius,
        child: Container(
          width: _getScreenWidth() / 1.23,
          height: 100,
          padding: Dimens.contentPadding,
          decoration: BoxDecoration(
            color: AppColors.contentColor,
            border: Border(
                left: BorderSide(
              width: 25,
              color: (widget.taskList[index].isDone == true)
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
    return GestureDetector(
      onTap: () {
        if(widget.taskList[index].isTypeOfText){
          Navigator.push(context,MaterialPageRoute(builder: (context) => TaskPageTextOnly(task_id: widget.taskList[index].id,)));
        }
        else{
          Navigator.push(context,MaterialPageRoute(builder: (context) => TaskPageWithImage(task: widget.taskList[index],)));
        }
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildContentTitle(index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text("${widget.taskList[index].text.technical_name}",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: 16,
          )),
    );
  }

  Widget _buildContentDeadline(index) {
    return Container(
        padding: Dimens.contentDeadlineTopPadding,
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
            borderRadius: Dimens.contentDeadlineBorderRadius,
            border: Border.all(
                width: 1,
                color: (_taskDone(index))
                    ? AppColors.deadlineDoneBorderColor
                    : AppColors.deadlineUnDoneBorderColor)),
        child: Center(
            child: Text("${AppLocalizations.of(context).translate('deadline')}",
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
    switch (widget.taskList[index].deadLine) {
      case null:
        return false;
    }
    return true;
  }

  bool _taskDone(index) {
    switch (widget.taskList[index].isDone) {
      case true:
        return true;
    }
    return false;
  }
}
