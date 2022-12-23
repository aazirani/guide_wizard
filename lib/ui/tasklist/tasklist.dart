import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/test/task.dart';
import 'package:boilerplate/ui/tasklist/tasklist_timeline.dart';
import 'package:boilerplate/utils/enums/enum.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [
    Task(
        title: "Application Dates",
        deadline: DateTime.now(),
        status: TaskStatus.notDone),
    Task(
        title: "Requirements",
        deadline: DateTime.now(),
        status: TaskStatus.notDone),
    Task(title: "Other", deadline: DateTime.now(), status: TaskStatus.notDone),
    Task(title: "Another", status: TaskStatus.notDone),
    Task(title: "Language Certificate", status: TaskStatus.Done),
    Task(title: "Housing", deadline: DateTime.now(), status: TaskStatus.Done),
    Task(title: "Health", deadline: DateTime.now(), status: TaskStatus.Done),
    Task(title: "Another", status: TaskStatus.Done),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(tasks));
  }

  //appBar methods .............................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.main_color,
        titleSpacing: 0,
        title: Text("University",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: Padding(
          padding: Dimens.back_button,
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {},
              color: AppColors.white),
        ));
  }

  // body methods ..............................................................

  Widget _buildBody(tasks) {
    return Stack(children: [
      _buildTaskProgressBar(),
      _buildExpandableTaskTimeline(),
    ]);
  }

  Widget _buildTaskProgressBar() {
    return Container(
        height: 150,
        color: AppColors.main_color,
        child: Padding(
            padding: Dimens.taskProgressBarPadding,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: Dimens.numberOfTasksPadding,
                      child: Text("4 tasks",
                          style: TextStyle(color: AppColors.white))),
                  SizedBox(height: 5),
                  _buildProgressBar(),
                ],
              ),
            )));
  }

  Widget _buildExpandableTaskTimeline() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: 0.85,
        maxChildSize: 1,
        minChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: AppColors.main_color,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: AppColors.white),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: scrollController,
                    itemCount: tasks.length,
                    itemBuilder: (context, i) {
                      return TaskListTimeLine(tasks: tasks, index: i);
                    },
                  ),
                ),
              ),
            
          );
        },
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        // color: Colors.amber,
        height: 20,
        width: _getScreenWidth() / 1.19,
        child: Padding(
            padding: EdgeInsets.only(right: 0, bottom: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                  // minHeight: 4,
                  value: 0.2,
                  backgroundColor: Colors.white,
                  valueColor:
                      AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
            )),
      ),
    );
  }

  // general methods ...........................................................
  double _getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }
}
