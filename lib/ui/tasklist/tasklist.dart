import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../tasklist/tasklist_timeline.dart';
import '../../models/task/task.dart';
import '../../utils/enums/enum.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // List<Task> tasks = [
  //   Task(
  //       title: "Application Dates",
  //       deadline: DateTime.now(),
  //       status: TaskStatus.notDone),
  //   Task(
  //       title: "Requirements",
  //       deadline: DateTime.now(),
  //       status: TaskStatus.notDone),
  //   Task(title: "Language Certificate", status: TaskStatus.Done),
  //   Task(
  //       title: "Private Housing",
  //       deadline: DateTime.now(),
  //       status: TaskStatus.Done),
  // ];

  List<Task> tasks = List<Task>.generate(
      20,
      (index) => Task(
            title: "hi",
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    toolbarHeight: 70,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Row(
                        children: [
                          IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {}),
                          // SizedBox(height: 10),
                          Text("University",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                    floating: true,
                    snap: true,
                    pinned: true,
                    expandedHeight: 170,
                    collapsedHeight: 70,
                    backgroundColor: AppColors.main_color.withOpacity(1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    centerTitle: false,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const <StretchMode>[
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      
                      background: SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container( 
                            height: 150, 
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, top: 80, bottom: 0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("4 tasks",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white)),
                                      )),
                                  Spacer(),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: _buildProgressBar()),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
            body: _buildBody(tasks)));
  }

  //appBar methods .............................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: _getScreenHeight() / 4,
      titleSpacing: 5,
      backgroundColor: AppColors.main_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      flexibleSpace: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, top: 60, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("University",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text("4 tasks",
                            style: TextStyle(fontSize: 15, color: Colors.white))
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildProgressBar()),
                ]),
          ),
        ),
      ),
    );
  }

  // body methods ..............................................................
  Widget _buildBody(tasks) {
    return TaskListTimeLine(tasks: tasks);
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
                  valueColor: AlwaysStoppedAnimation(
                      Color.fromARGB(255, 47, 205, 144))),
            )),
      ),
    );
  }

  // general methods ...........................................................
  double _getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }
}
