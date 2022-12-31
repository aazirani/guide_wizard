import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/widgets/sub_task_widget.dart';
import 'package:boilerplate/widgets/blocks_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:render_metrics/render_metrics.dart';

class TaskPageTextOnly extends StatefulWidget {
  Task task;

  TaskPageTextOnly({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPageTextOnly> createState() => _TaskPageTextOnlyState();
}

class _TaskPageTextOnlyState extends State<TaskPageTextOnly> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();

  @override
  void initState() {
    super.initState();
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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 20),
                child: Text(widget.task.description.string, style: TextStyle(fontSize: 20),),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.task.sub_tasks.length,
                itemBuilder: (context, i) {
                  return SubTaskWidget(
                    index: i,
                    subTasks: widget.task.sub_tasks,
                    renderManager: renderManager,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: BlocksAppBarWidget(
        isDone: widget.task.isDone,
        appBarSize: 70.0,
        title: widget.task.text.string,
      ),
      body: _buildScaffoldBody(),
    );
  }
}
