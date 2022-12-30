import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/step/step.dart' as s;
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/models/title/title.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/ui/compressed_tasklist_timeline/compressed_task_list_timeline.dart';
import 'package:boilerplate/ui/step_slider/step_slider_widget.dart';
import 'package:boilerplate/ui/step_timeline/step_timeline.dart';
import 'package:boilerplate/utils/enums/enum.dart';
import 'package:boilerplate/models/step/step_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/models/sub_task/sub_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 late StepStore _stepStore; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _stepStore = Provider.of<StepStore>(context);
  }
  final StepList stepList = StepList(steps: List<s.Step>.generate(
      4,
      (index) => s.Step(
          id: 1,
          name: TechnicalName(
              id: 1,
              technical_name: "Info",
              created_at: "0",
              creator_id: 1,
              updated_at: "0"),
          description: TechnicalName(
              id: 1,
              technical_name: "Info stuff",
              created_at: "0",
              creator_id: 1,
              updated_at: "0"),
          order: 1,
          image: null,
          tasks: List<Task>.generate(
    10,
    (index) => Task(
      id: 0,
      text: TechnicalName(
          id: 1,
          technical_name: "Housing",
          creator_id: 1,
          created_at: "0",
          updated_at: "0"),
      description: TechnicalName(
          id: 1,
          technical_name: "Housing",
          creator_id: 1,
          created_at: "0",
          updated_at: "0"),
      type: "sth",
      sub_tasks: List<SubTask>.generate(
          10,
          (index) => SubTask(
              id: 1,
              task_id: 0,
              title: TechnicalName(
                  id: 0,
                  technical_name: "Dorm",
                  creator_id: 1,
                  created_at: "0",
                  updated_at: "0"),
              markdown: TechnicalName(
                  id: 1,
                  technical_name: "markdown",
                  creator_id: 1,
                  created_at: "0",
                  updated_at: "0"),
              deadline: TechnicalName(
                  id: 1,
                  technical_name: "deadline",
                  creator_id: 1,
                  created_at: "0",
                  updated_at: "0"),
              order: 1,
              creator_id: "1",
              created_at: "0",
              updated_at: "0")),
      creator_id: "1",
      created_at: "0",
      updated_at: "0",
      image1: null,
      image2: null,
      fa_icon: null,
      quesions: [],
    ),
  )
)));

  // List<s.Step> steps = [
  //   s.Step(
  //       title: "Info",
  //       numTasks: 20,
  //       percentage: 0.2,
  //       status: StepStatus.isDone,
  //       tasks: List<Task>.generate(20, (index) => Task(title: 'task $index'))),
  //   s.Step(
  //       title: "Documents",
  //       numTasks: 4,
  //       percentage: 1,
  //       status: StepStatus.isPending,
  //       tasks: [
  //         Task(title: "Application Dates"),
  //         Task(title: "Private Housing"),
  //         Task(title: "Requirements"),
  //         Task(title: "Language Certificate", deadline: DateTime.now())
  //       ]),
  //   s.Step(
  //       title: "Housing",
  //       numTasks: 4,
  //       percentage: 0,
  //       tasks: List<Task>.generate(
  //           4,
  //           (index) => Task(
  //                 title: 'task $index',
  //               ))),
  //   s.Step(
  //       title: "University",
  //       numTasks: 12,
  //       percentage: 0,
  //       tasks: List<Task>.generate(12, (index) => Task(title: "task $index")))
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
  Widget _buildBody() {
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
        child: _buildScreenElements(),
      ),
    );
  }

  Widget _buildScreenElements() {
    return Column(
      children: [
        //steps (/)
        _buildCurrentStepIndicator(),
        //step slider
        StepSliderWidget(stepList: stepList),
        //step timeline
        StepTimeLine(pending: 1, stepNo: 3, stepList: stepList),
        SizedBox(height: 25),
        _buildInProgressText(),
        SizedBox(height: 10),
        //task compressed timeline
        CompressedBlocklistTimeline(stepList: stepList),
      ],
    );
  }

  Widget _buildCurrentStepIndicator() {
    return Padding(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
        ),
        child: Row(children: [
          _buildStepsText(),
          SizedBox(width: 10),
          _buildCurrentStepText(_stepStore),
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
        builder: (_) => Text("${stepStore.currentStep}/${Dimens.stepNo}",
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
