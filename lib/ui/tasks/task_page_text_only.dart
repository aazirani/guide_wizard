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
  int taskId;

  TaskPageTextOnly({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskPageTextOnly> createState() => _TaskPageTextOnlyState();
}

class _TaskPageTextOnlyState extends State<TaskPageTextOnly> {
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
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var titleId = _dataStore.getTaskById(widget.taskId).text;
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
          taskId: widget.taskId,
          title: _technicalNameWithTranslationsStore.getTranslation(titleId),
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
    return ListView(
      children: [
        _buildDescription(),
        _buildSubTasksList(),
      ],
    );
  }

  _buildDescription() {
    var descriptionId = _dataStore.getTaskById(widget.taskId).description;
    return Padding(
      padding: Dimens.taskPageTextOnlyListViewPadding,
      child: Observer(
        builder: (context) {
          return Text(
            _technicalNameWithTranslationsStore.getTranslation(descriptionId),
            style: TextStyle(fontSize: Dimens.taskDescriptionFont, color: AppColors.main_color),

          );
        },
      ),
    );
  }

  _buildSubTasksList() {
    
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _dataStore.getTaskById(widget.taskId).sub_tasks.length,
      itemBuilder: (context, i) {
        var deadlineId = _dataStore.getDeadlineId(widget.taskId, i);
        return SubTaskWidget(
          index: i,
          subTasks: _dataStore.getTaskById(widget.taskId).sub_tasks,
          renderManager: renderManager,
          deadline: _technicalNameWithTranslationsStore.getTranslation(deadlineId),
        );
      },
    );
  }
}
