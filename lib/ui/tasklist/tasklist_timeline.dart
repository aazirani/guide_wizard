import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/constants/lang_keys.dart';
import 'package:boilerplate/stores/data/data_store.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/ui/tasks/task_page_text_only.dart';
import 'package:boilerplate/ui/tasks/task_page_with_image.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class TaskListTimeLine extends StatefulWidget {
  // final TaskList taskList;
  final int taskNumber;
  TaskListTimeLine({Key? key, required this.taskNumber}) : super(key: key);

  @override
  State<TaskListTimeLine> createState() => _TaskListTimeLineState();
}

class _TaskListTimeLineState extends State<TaskListTimeLine> {
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _navigateToTaskPage();
        },
        child: _buildTimeline(widget.taskNumber));
  }

  Widget _buildTimeline(taskNumber) {
    return TimelineTile(
      nodePosition: 0.05,
      contents: _buildContents(taskNumber),
      node: TimelineNode(
        indicator: _buildIndicator(taskNumber),
        startConnector: _buildConnector(),
        endConnector: _buildConnector(),
      ),
    );
  }

  Widget _buildIndicator(taskNumber) {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: (_taskDone(taskNumber))
            ? DiamondIndicator(fill: true)
            : DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: AppColors.tasklistConnectorColor);
  }

  Widget _buildContents(taskNumber) {
    return Padding(
      padding: Dimens.contentContainerPadding,
      child: Material(
        elevation: 5,
        borderRadius: Dimens.contentContainerBorderRadius,
        child: ClipRRect(
          borderRadius: Dimens.contentContainerBorderRadius,
          child: Container(
            width: _getScreenWidth() / 1.23,
            padding: Dimens.contentPadding,
            decoration: BoxDecoration(
              color: AppColors.contentColor,
              border: Border(
                  left: BorderSide(
                width: 25,
                color: (_dataStore.getTaskIsDoneStatus(taskNumber) == true)
                    ? AppColors.contentDoneBorderColor
                    : AppColors.contentUnDoneBorderColor,
              )),
            ),
            child: _buildInsideElements(taskNumber),
          ),
        ),
      ),
    );
  }

  Widget _buildInsideElements(taskNumber) {
    return GestureDetector(
      onTap: () {
        _navigateToTaskPage();
      },
      child: Container(
        child: Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_deadLineAvailable(taskNumber))
                    ? [
                        _buildContentTitle(taskNumber),
                        _buildContentDeadline(taskNumber),
                      ]
                    : [Center(child: _buildContentTitle(taskNumber))],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTitle(taskNumber) {
    //text id of the task we want to find the title of
    var title_id = _dataStore.getTaskTitleIdByIndex(taskNumber);
    return Flexible(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${_technicalNameWithTranslationsStore.getTranslation(title_id)} ",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: Dimens.taskListTimeLineContentTitle,
          ),
        ),
      ),
    );
  }

  Widget _buildContentDeadline(taskNumber) {
    return Container(
        padding: Dimens.contentDeadlineTopPadding,
        width: 80,
        height: 40,
        child: (_deadLineAvailable(taskNumber))
            ? _buildDeadlineContainer(taskNumber)
            : null);
  }

  Widget _buildDeadlineContainer(taskNumber) {
    return Container(
        height: 10,
        decoration: BoxDecoration(
            borderRadius: Dimens.contentDeadlineBorderRadius,
            border: Border.all(
                width: 1,
                color: (_taskDone(taskNumber))
                    ? AppColors.deadlineDoneBorderColor
                    : AppColors.deadlineUnDoneBorderColor)),
        child: Center(
            child: Text("${AppLocalizations.of(context).translate(LangKeys.deadline)}",
                style: TextStyle(
                    fontSize: 13,
                    color: (_taskDone(taskNumber)
                        ? AppColors.deadlineTextDoneColor
                        : AppColors.deadlineTextUnDoneColor)))));
  }

  //general methods ............................................................
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  bool _deadLineAvailable(taskNumber) {
    bool status = _dataStore.taskList.tasks[taskNumber].sub_tasks.any(
        (sub_task) => _technicalNameWithTranslationsStore
            .getTranslation(sub_task.deadline)
            .isNotEmpty);
    switch (status) {
      case false:
        return false;
    }
    return true;
  }

  bool _taskDone(taskNumber) {
    switch (_dataStore.getTaskIsDoneStatus(taskNumber)) {
      case true:
        return true;
    }
    return false;
  }

  void _navigateToTaskPage() {
    final taskNumber = widget.taskNumber;
    final taskType = _dataStore.getTaskType(taskNumber);
    final taskId = _dataStore.getTaskId(taskNumber);
    final task = _dataStore.getTaskByIndex(taskNumber);

    final taskPage = taskType
        ? TaskPageTextOnly(taskId: taskId)
        : TaskPageWithImage(task: task);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => taskPage),
    );
  }
}
