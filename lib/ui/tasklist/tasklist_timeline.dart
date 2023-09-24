import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/ui/tasks/task_page_text_only.dart';
import 'package:guide_wizard/ui/tasks/task_page_with_image.dart';
import 'package:guide_wizard/widgets/diamond_indicator.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class TaskListTimeLine extends StatefulWidget {
  final AppStep step;
  final Task task;
  final int index;
  TaskListTimeLine({Key? key, required this.step, required this.task, required this.index}) : super(key: key);

  @override
  State<TaskListTimeLine> createState() => _TaskListTimeLineState();
}

class _TaskListTimeLineState extends State<TaskListTimeLine> {
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
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
        color: context.transparent,
        width: 8,
        height: 8,
        child: (widget.task.isDone)
            ? DiamondIndicator(fill: true)
            : DiamondIndicator());
  }

  Widget _buildConnector() {
    return SolidLineConnector(
        direction: Axis.vertical, color: context.secondaryColor);
  }

  Widget _buildContents() {
    return Padding(
      padding: Dimens.taskListTimeLine.contentContainerPadding,
      child: Material(
        elevation: widget.task.isDone ? 3 : 4,
        borderRadius: Dimens.taskListTimeLine.contentContainerBorderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: context.lightBackgroundColor,
            borderRadius: Dimens.taskListTimeLine.contentContainerBorderRadius,
          ),
          child: Container(
            padding: Dimens.taskListTimeLine.contentPadding,
            constraints: BoxConstraints(
              minHeight: Dimens.taskListTimeLine.containerMinHeight,
              maxHeight: Dimens.taskListTimeLine.containerMinHeight,
            ),
            decoration: BoxDecoration(
              color: context.lightBackgroundColor,
              borderRadius: Dimens.taskListTimeLine.contentContainerBorderRadius,
              border: Border.all(
                width: widget.task.isDone ? 1 : 3,
                color: (widget.task.isDone)
                    ? context.secondaryContainerColor
                    : context.primaryColor,
              ),
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
            widget.task.isDone ? _buildDoneBadge() : Container(),
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
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildDoneBadge() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          height: Dimens.taskListTimeLine.doneBadgeHeight,
          width: Dimens.taskListTimeLine.doneBadgeWidth,
          decoration: BoxDecoration(
              border: Border.all(color: context.secondaryContainerColor),
              color: context.doneBadgeColor,
              borderRadius: BorderRadius.all(Radius.circular(Dimens.taskListTimeLine.doneBadgeBorderRadius))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 3,
                  child: Text(
                    "${_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.done_task)}",
                      style: TextStyle(
                          color: context.primaryColor,
                          fontSize: Dimens.taskListTimeLine.doneBadgeFontSize,
                          fontWeight: FontWeight.w800))),
            ],
          )),
    );
  }

  Widget _buildContentDeadline() {
    return Container(
        padding: Dimens.taskListTimeLine.contentDeadlineTopPadding,
        width: 80,
        height: 40,
        child: (_deadLineAvailable())
            ? _buildDeadlineContainer()
            : null);
  }

  Widget _buildDeadlineContainer() {
    return Container(
        height: Dimens.taskListTimeLine.deadlineContainerHeight,
        decoration: BoxDecoration(
            color: widget.task.isDone
                ? context.lightBackgroundColor
                : context.deadlineBadgeColor,
            borderRadius: Dimens.taskListTimeLine.contentDeadlineBorderRadius,
            border: Border.all(
                width: Dimens.taskListTimeLine.deadlineBorderWidth,
                color: (widget.task.isDone)
                    ? context.secondaryContainerColor
                    : context.deadlineColor)),
        child: Center(
            child: Text("${_technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.deadline)}",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    color: (widget.task.isDone)
                        ? context.secondaryContainerColor
                        : context.primaryColor))));
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
