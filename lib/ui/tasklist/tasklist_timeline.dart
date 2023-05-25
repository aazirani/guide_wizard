import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/ui/tasks/task_page_text_only.dart';
import 'package:boilerplate/ui/tasks/task_page_with_image.dart';
import 'package:boilerplate/widgets/diamond_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:boilerplate/stores/data/data_store.dart';

class TaskListTimeLine extends StatefulWidget {
  // final TaskList taskList;
  final int task_number;
  TaskListTimeLine({Key? key, required this.task_number}) : super(key: key);

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
    return _buildTimeline(widget.task_number);
  }

  Widget _buildTimeline(task_number) {
    return TimelineTile(
      nodePosition: 0.05,
      contents: _buildContents(task_number),
      node: TimelineNode(
        indicator: _buildIndicator(task_number),
        startConnector: _buildConnector(),
        endConnector: _buildConnector(),
      ),
    );
  }

  Widget _buildIndicator(task_number) {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: (_taskDone(task_number))
            ? DiamondIndicator(fill: true)
            : DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: AppColors.tasklistConnectorColor);
  }

  Widget _buildContents(task_number) {
    return Padding(
      padding: Dimens.contentContainerPadding,
      child: Material(
        elevation: 5,
        borderRadius: Dimens.contentContainerBorderRadius,
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
                color: (_dataStore.taskList.tasks[task_number].isDone == true)
                    ? AppColors.contentDoneBorderColor
                    : AppColors.contentUnDoneBorderColor,
              )),
            ),
            child: _buildInsideElements(task_number),
          ),
        ),
      ),
    );
  }

  Widget _buildInsideElements(task_number) {
    return GestureDetector(
      onTap: () {
        if (_dataStore.taskList.tasks[task_number].isTypeOfText) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskPageTextOnly(
                        task_id: _dataStore.taskList.tasks[task_number].id,
                      )));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskPageWithImage(
                        task: _dataStore.taskList.tasks[task_number],
                      )));
        }
      },
      child: Container(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: (_deadLineAvailable(task_number))
                  ? [
                      _buildContentTitle(task_number),
                      _buildContentDeadline(task_number),
                    ]
                  : [Center(child: _buildContentTitle(task_number))],
            ),
            Spacer(),
            _buildContentMoreIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTitle(task_number) {
    //text id of the task we want to find the title of
    var title_id = _dataStore.taskList.tasks[task_number].text.id;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
          "${_technicalNameWithTranslationsStore.getTechnicalNames(title_id)}",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: 16,
          )),
    );
  }

  Widget _buildContentDeadline(task_number) {
    return Container(
        padding: Dimens.contentDeadlineTopPadding,
        width: 80,
        height: 40,
        child: (_deadLineAvailable(task_number))
            ? _buildDeadlineContainer(task_number)
            : null);
  }

  Widget _buildDeadlineContainer(task_number) {
    return Container(
        height: 10,
        decoration: BoxDecoration(
            borderRadius: Dimens.contentDeadlineBorderRadius,
            border: Border.all(
                width: 1,
                color: (_taskDone(task_number))
                    ? AppColors.deadlineDoneBorderColor
                    : AppColors.deadlineUnDoneBorderColor)),
        child: Center(
            child: Text("${AppLocalizations.of(context).translate('deadline')}",
                style: TextStyle(
                    fontSize: 13,
                    color: (_taskDone(task_number)
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
  bool _deadLineAvailable(task_number) {
    switch (_dataStore.taskList.tasks[task_number].deadLine) {
      case null:
        return false;
    }
    return true;
  }

  bool _taskDone(task_number) {
    switch (_dataStore.taskList.tasks[task_number].isDone) {
      case true:
        return true;
    }
    return false;
  }
}
