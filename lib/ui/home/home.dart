import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/ui/step slider/step_slider_widget.dart';
import 'package:boilerplate/ui/step timeline/step_timeline.dart';
import 'package:boilerplate/models/step/step.dart' as s;
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/utils/enums/enum.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/compressed%20tasklist%20timeline/compressed_task_list_timeline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        tasks: List<Task>.generate(
            4,
            (index) => Task(
                  title: 'task $index',
                ))),
    s.Step(
        title: "University",
        numTasks: 12,
        percentage: 0,
        tasks: List<Task>.generate(12, (index) => Task(title: "task $index")))
  ];

  @override
  Widget build(BuildContext context) {
    final stepStore = Provider.of<StepStore>(context);
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: _buildBody(stepStore),
    );
  }

//appbar build methods .........................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 60,
      titleSpacing: 5,
      backgroundColor: AppColors.main_color,
      title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Welcome Guide",
              style: TextStyle(color: AppColors.title_color, fontSize: 20))),
    );
  }

//body build methods ...........................................................
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
        child: _buildScreenElements(stepStore),
      ),
    );
  }

  Widget _buildScreenElements(stepStore) {
    return Column(
      children: [
        //steps (/)
        _buildCurrentStepIndicator(stepStore),
        //step slider
        StepSliderWidget(steps: steps),
        //step timeline
        StepTimeLine(pending: 1, stepNo: 3, steps: steps),
        SizedBox(height: 25),
        //in progress
        _buildInProgressText(),
        SizedBox(height: 10),
        //task compressed timeline
        CompressedBlocklistTimeline(steps: steps),
      ],
    );
  }

  Widget _buildCurrentStepIndicator(stepStore) {
    return Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
        ),
        child: Row(children: [
          _buildStepsText(),
          SizedBox(width: 10),
          _buildCurrentStepText(stepStore),
        ]));
  }

  Widget _buildStepsText() {
    return Text("Steps",
        style: TextStyle(
            color: AppColors.main_color,
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }

  Widget _buildCurrentStepText(stepStore) {
    return Observer(
        builder: (_) => Text("${stepStore.currentStep}/4",
            style: TextStyle(color: AppColors.main_color)));
  }

  Widget _buildInProgressText() {
    return Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("In Progress",
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.main_color,
                        fontWeight: FontWeight.bold)))); 
  }
}
