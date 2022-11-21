import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../step slider/step_slider_widget.dart';
import '../step timeline/step_timeline.dart';
import '../../models/step/step.dart' as s;
import '../../models/task/task.dart';
import '../../utils/enums/enum.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../stores/step/step_store.dart';
import '../compressed blocklist timeline/compressed_task_list_timeline.dart';

import 'package:timelines/timelines.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // StepStore stepStore = StepStore();

  double _getScreenHeight() => MediaQuery.of(context).size.height;
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  List<s.Step> steps = [
    s.Step(
        title: "Info",
        numTasks: 20,
        percentage: 0.2,
        status: StepStatus.isDone,
        tasks: List<Task>.generate(20, (index) => Task(title: 'task $index'))),
    s.Step(
        title: "Documents",
        numTasks: 4,
        percentage: 1,
        status: StepStatus.isPending,
        tasks: [
          Task(title: "Application Dates"),
          Task(title: "Private Housing"),
          Task(title: "Requirements"),
          Task(title: "Language Certificate", deadline: DateTime.now())
        ]),
    s.Step(
        title: "Housing",
        numTasks: 4,
        percentage: 0,
        tasks: List<Task>.generate(4, (index) => Task(title: 'task $index',))),
    s.Step(
        title: "University",
        numTasks: 12,
        percentage: 0,
        tasks: List<Task>.generate(12, (index) => Task(title: "task $index")))
  ];

  @override
  Widget build(BuildContext context) {
    final stepStore = Provider.of<StepStore>(context);
    print(stepStore.currentStep);
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 5,
        backgroundColor: AppColors.main_color,
        title: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text("Welcome Guide",
                style: TextStyle(color: Colors.white, fontSize: 20))),
      ),
      // body: _buildBody(context),
      body: _buildBody(stepStore),
    );
  }

/* timline */

  // Widget _buildScrollableTimeline() {
  //   return Container(
  //     height: _getScreenHeight() / 3,
  //     child: Align(
  //       alignment: Alignment.centerLeft,
  //       child: StepTimeLineWidget(),
  //     ),
  //   );
  // }

  Widget _buildBody(stepStore) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 251, 251),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                  top: 30,
                  left: 15,
                ),
                child: Row(children: [
                  Text("Steps",
                      style: TextStyle(
                          color: AppColors.main_color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Observer(
                      builder: (_) => Text("${stepStore.currentStep}/4",
                          style: TextStyle(color: AppColors.main_color)))
                ])),
            //step slider
            StepSliderWidget(
              steps: steps,
            ),
            StepTimeLine(pending: 3, stepNo: 3, steps: steps),
            SizedBox(height: 25),
            Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("In Progress",
                        style: TextStyle(
                            fontSize: 18,
                            color: AppColors.main_color,
                            fontWeight: FontWeight.bold)))),
            SizedBox(height: 10),
            Container(
                // margin: EdgeInsets.only(right: 0),
                padding: EdgeInsets.only(left: 20, right: 20),
                // height: 300,
                child: CompressedBlocklistTimeline(steps: steps)),
            // SizedBox(height:   20),
            // _buildScrollableTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody2(BuildContext context) {
    return Container(
      color: AppColors.main_color,
      // height: 160.0,
      child: Stack(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 251, 251, 251),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("hi"),
                  //  StepTimeLine(pending: 2, stepNo: 3),
                  // Padding(
                  //     padding: EdgeInsets.only(top: 15, left: 15),
                  //     child: Row(children: [Text("Steps"), Text("4/4")])),
                  // //step slider
                  // StepSliderWidget(
                  //   steps: steps,
                  // ),
                  // SizedBox(height: 1),
                  // //step timeline
                  // // StepTimeLine(pending: 2, stepNo: 3),
                  // SizedBox(height: 20),
                  // Padding(
                  //     padding: EdgeInsets.only(left: 20),
                  //     child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Text("In Progress",
                  //             style: TextStyle(fontSize: 18)))),
                  // SizedBox(height: 20),
                  // _buildScrollableTimeline(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
