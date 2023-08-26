import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/tasks/task_page_text_only.dart';
import 'package:guide_wizard/ui/tasks/task_page_with_image.dart';
import 'package:guide_wizard/widgets/diamond_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class TaskListTimeLine extends StatefulWidget {
  final AppStep step;
  final Task task;
  final int index;
  TaskListTimeLine({Key? key, required this.step, required this.task, required this.index}) : super(key: key);

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
        child: _buildTimeline());
  }

  Widget _buildTimeline() {
    return Observer(
      builder: (_) => TimelineTile(
        nodePosition: 0.05,
        contents: _buildContents(),
        node: TimelineNode(
          indicator: _buildIndicator(),
          startConnector: widget.index == 0
              ? Container()
              : _buildConnector(),
          endConnector: widget.index == widget.step.tasks.length - 1
              ? Container()
              : _buildConnector(),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
        color: AppColors.transparent,
        width: 8,
        height: 8,
        child: (widget.task.isDone)
            ? DiamondIndicator(fill: true)
            : DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: AppColors.tasklistConnectorColor);
  }

  Widget _buildContents() {
    return Padding(
      padding: Dimens.contentContainerPadding,
      child: Material(
        elevation: 5,
        borderRadius: Dimens.contentContainerBorderRadius,
        child: ClipRRect(
          borderRadius: Dimens.contentContainerBorderRadius,
          child: Container(
            padding: Dimens.contentPadding,
            constraints: BoxConstraints(
              minHeight: Dimens.taskListTimeLineContainerMinHeight,
            ),
            decoration: BoxDecoration(
              color: AppColors.contentColor,
              border: Border(
                  left: BorderSide(
                width: 25,
                color: (widget.task.isDone)
                    ? AppColors.contentDoneBorderColor
                    : AppColors.contentUnDoneBorderColor,
              )),
            ),
            child: _buildInsideElements(),
          ),
        ),
      ),
    );
  }

  Widget _buildInsideElements() {
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
                children: (_deadLineAvailable())
                    ? [
                        _buildContentTitle(),
                        _buildContentDeadline(),
                      ]
                    : [_buildContentTitle()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentTitle() {
    return Flexible(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${_technicalNameWithTranslationsStore.getTranslation(widget.task.text)} ",
          style: TextStyle(
            color: AppColors.main_color,
            fontSize: Dimens.taskListTimeLineContentTitle,
          ),
        ),
      ),
    );
  }

  Widget _buildContentDeadline() {
    return Container(
        padding: Dimens.contentDeadlineTopPadding,
        width: 80,
        height: 40,
        child: (_deadLineAvailable())
            ? _buildDeadlineContainer()
            : null);
  }

  Widget _buildDeadlineContainer() {
    return Container(
        height: 10,
        decoration: BoxDecoration(
            borderRadius: Dimens.contentDeadlineBorderRadius,
            border: Border.all(
                width: 1,
                color: (widget.task.isDone)
                    ? AppColors.deadlineDoneBorderColor
                    : AppColors.deadlineUnDoneBorderColor)),
        child: Center(
            child: Text("${_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.deadline)}",
                style: TextStyle(
                    fontSize: 13,
                    color: (widget.task.isDone)
                        ? AppColors.deadlineTextDoneColor
                        : AppColors.deadlineTextUnDoneColor))));
  }

  //general methods ............................................................

  bool _deadLineAvailable() {
    return widget.task.sub_tasks.any(
            (sub_task) => _technicalNameWithTranslationsStore
            .getTranslation(sub_task.deadline)
            .isNotEmpty);
  }

  void _navigateToTaskPage() {
    Widget taskPage = Container();
    if(widget.task.isTypeOfText){
      taskPage = TaskPageTextOnly(
        task: widget.task,
        step: widget.step,
      );
    }
    if(widget.task.isTypeOfImage){
      taskPage = TaskPageWithImage(
        task: widget.task,
        step: widget.step,
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => taskPage),
    );
  }
}
