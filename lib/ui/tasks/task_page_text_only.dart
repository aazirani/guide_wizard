import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/task/tasks_store.dart';
import 'package:boilerplate/widgets/sub_task_widget.dart';
import 'package:boilerplate/widgets/blocks_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageTextOnly extends StatefulWidget {
  int task_id;

  TaskPageTextOnly({Key? key, required this.task_id}) : super(key: key);

  @override
  State<TaskPageTextOnly> createState() => _TaskPageTextOnlyState();
}

class _TaskPageTextOnlyState extends State<TaskPageTextOnly> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  // stores:--------------------------------------------------------------------
  late TasksStore _tasksStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _tasksStore = Provider.of<TasksStore>(context);
  }

  @override
  void initState() {
    super.initState();
  }

  _buildDescription(){
    return Padding(
      padding: Dimens.taskPageTextOnlyListViewPadding,
      child: Observer(
        builder: (context) {
          return Text(_tasksStore.getTaskById(widget.task_id).description.string, style: TextStyle(fontSize: 20),);
        },
      ),
    );
  }

  _buildSubTasksList(){
    return Observer(
      builder: (context) {
        return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _tasksStore.getTaskById(widget.task_id).sub_tasks.length,
          itemBuilder: (context, i) {
            return SubTaskWidget(
              index: i,
              subTasks: _tasksStore.getTaskById(widget.task_id).sub_tasks,
              renderManager: renderManager,
            );
          },
        );
      },
    );
  }

  _buildPageContent(){
    return ListView(
      children: [
        _buildDescription(),
        _buildSubTasksList(),
      ],
    );
  }

  Widget _buildScaffoldBody() {
    return SizedBox.expand(
      child: Container(
        color: AppColors.main_color,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: AppColors.bright_foreground_color),
          child: _buildPageContent(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        isDone: _tasksStore.getTaskById(widget.task_id).isDone,
        appBarSize: 70.0,
        title: _tasksStore.getTaskById(widget.task_id).text.string,
      ),
      body: _buildScaffoldBody(),
    );
  }
}
