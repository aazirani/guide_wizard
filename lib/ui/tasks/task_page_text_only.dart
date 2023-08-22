import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/widgets/sub_task_widget.dart';
import 'package:guide_wizard/widgets/task_page_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageTextOnly extends StatefulWidget {
  final int taskId;
  final int stepId;
  TaskPageTextOnly({Key? key, required this.taskId, required this.stepId}) : super(key: key);

  @override
  State<TaskPageTextOnly> createState() => _TaskPageTextOnlyState();
}

class _TaskPageTextOnlyState extends State<TaskPageTextOnly> {
  get task => _dataStore.getStepById(widget.stepId).tasks.firstWhere((task) => task.id == widget.taskId);
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
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
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        taskId: task.id,
        stepId: widget.stepId,
        title: _technicalNameWithTranslationsStore.getTranslation(task.text),
      ),
      body: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    return SizedBox.expand(
      child: Container(
        color: AppColors.main_color,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: Dimens.taskPageTextOnlyScaffoldBorder,
              color: AppColors.bright_foreground_color),
          child: _buildPageContent(),
        ),
      ),
    );
  }

  _buildPageContent() {
    return RawScrollbar(
      child: ListView(
        children: [
          _technicalNameWithTranslationsStore.getTranslation(task.description) == "" ? SizedBox(height: Dimens.taskPageTextOnlyListViewPadding.top,) : _buildDescription(),
          _buildSubTasksList(),
        ],
      ),
    );
  }

  _buildDescription() {
    return Padding(
      padding: Dimens.taskPageTextOnlyListViewPadding,
      child: Text(
        _technicalNameWithTranslationsStore.getTranslation(task.description),
        style: TextStyle(fontSize: Dimens.taskDescriptionFont, color: AppColors.main_color),
      ),
    );
  }

  _buildSubTasksList() {
    
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: task.sub_tasks.length,
      itemBuilder: (context, i) {
        return Observer(
          builder: (_) => SubTaskWidget(
            index: i,
            taskId: task.id,
            stepId: widget.stepId,
            renderManager: renderManager,
          ),
        );
      },
    );
  }
}
