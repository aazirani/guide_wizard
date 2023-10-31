import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/sub_task_widget.dart';
import 'package:guide_wizard/widgets/task_page_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class TaskPageTextOnly extends StatefulWidget {
  final Task task;
  final AppStep step;
  TaskPageTextOnly({Key? key, required this.task, required this.step}) : super(key: key);

  @override
  State<TaskPageTextOnly> createState() => _TaskPageTextOnlyState();
}

class _TaskPageTextOnlyState extends State<TaskPageTextOnly> {

  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  final scrollController = ScrollController();
  // stores:--------------------------------------------------------------------
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: context.primaryColor,
        appBar: BlocksAppBarWidget(
          task: widget.task,
          step: widget.step,
          title: _technicalNameWithTranslationsStore.getTranslation(widget.task.text),
        ),
        body: _buildScaffoldBody(),
      ),
    );
  }

  Widget _buildScaffoldBody() {
    return SizedBox.expand(
      child: Container(
        color: context.primaryColor,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: Dimens.taskPage.textOnlyScaffoldBorder,
              color: context.lightBackgroundColor),
          child: _buildPageContent(),
        ),
      ),
    );
  }

  _buildPageContent() {
    return RawScrollbar(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        children: [
          _technicalNameWithTranslationsStore.getTranslation(widget.task.description) == "" ? SizedBox(height: Dimens.taskPage.textOnlyListViewPadding.top,) : _buildDescription(),
          _buildSubTasksList(),
        ],
      ),
    );
  }

  _buildDescription() {
    return Padding(
      padding: Dimens.taskPage.textOnlyListViewPadding,
      child: Text(
        _technicalNameWithTranslationsStore.getTranslation(widget.task.description),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: context.textOnLightBackgroundColor,)
      ),
    );
  }

  _buildSubTasksList() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.task.sub_tasks.length,
      itemBuilder: (context, i) {
        return SubTaskWidget(
          index: i,
          task: widget.task,
          step: widget.step,
          renderManager: renderManager,
        );
      },
    );
  }
}
