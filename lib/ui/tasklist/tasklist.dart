import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/ui/home/home.dart';
import 'package:boilerplate/ui/tasklist/tasklist_timeline.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/widgets/measure_size.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:boilerplate/stores/task_list/task_list_store.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/stores/step/steps_store.dart';
import 'package:boilerplate/stores/step/step_store.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late TaskListStore _taskListStore;
  late StepsStore _stepsStore;
  late StepStore _stepStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _taskListStore = Provider.of<TaskListStore>(context);
    _stepsStore = Provider.of<StepsStore>(context);
    _stepStore = Provider.of<StepStore>(context);
  }

  var progressBarSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.main_color,
        appBar: _buildAppBar(),
        body: _buildBody());
  }

  //appBar methods .............................................................
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppColors.main_color,
        titleSpacing: 0,
        title: Observer(
          builder: (_) => Text("${_stepsStore.stepList.steps[_stepStore.currentStep-1].name.technical_name}",
              style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ),
        leading: Padding(
          padding: Dimens.back_button,
          child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              color: AppColors.white),
        ));
  }

  // body methods ..............................................................

  Widget _buildBody() {
    return Stack(children: [
      MeasureSize(
          onChange: (Size size) {
            setState(() {
              progressBarSize = size;
            });
          },
          child: _buildTaskProgressBar()),
      _buildExpandableTaskTimeline(),
    ]);
  }

  Widget _buildTaskProgressBar() {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: FittedBox(
          child: Padding(
        padding: Dimens.taskProgressBarPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: Dimens.numberOfTasksPadding,
                child: Observer(
                  builder: (_) => Text(
                      "${_taskListStore.taskList.numTasks} ${AppLocalizations.of(context).translate('tasks')}",
                      style: TextStyle(color: AppColors.white)),
                )),
            SizedBox(height: 5),
            _buildProgressBar(),
          ],
        ),
      )),
    );
  }

  Widget _buildExpandableTaskTimeline() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: _getProgressBarHeight(),
        maxChildSize: 1,
        minChildSize: _getProgressBarHeight(),
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
              child: Observer(
                builder: (_) => ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  itemCount: _taskListStore.taskList.numTasks,
                  itemBuilder: (context, i) {
                    return TaskListTimeLine(index: i);
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
    return Container(
      height: 20,
      width: _getScreenWidth() / 1.19,
      child: Padding(
          padding: EdgeInsets.only(right: 0, bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
                value: _taskListStore.taskList.noOfDoneTasks()/100,
                backgroundColor: AppColors.white,
                valueColor:
                    AlwaysStoppedAnimation(AppColors.progressBarValueColor)),
          )),
    );
  }

  // general methods ...........................................................
  double _getProgressBarHeight() {
    return (_getScreenHeight() -
            (progressBarSize.height + _getStatusBarHeight())) /
        _getScreenHeight();
  }

  double _getScreenWidth() {
    return MediaQuery.of(context).size.width;
  }

  double _getScreenHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _getStatusBarHeight() {
    return MediaQuery.of(context).viewPadding.top;
  }
}
