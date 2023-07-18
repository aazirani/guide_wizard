import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/step/step_store.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boilerplate/models/task/task.dart';
import 'package:boilerplate/stores/data/data_store.dart';

import 'package:boilerplate/ui/tasklist/tasklist.dart';

class BlocksAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  int taskId;
  double appBarSize;
  String title;
  BlocksAppBarWidget(
      {Key? key,
      required this.taskId,
      this.appBarSize = Dimens.blocksAppBarWidgetHeight,
      required this.title})
      : super(key: key);

  @override
  State<BlocksAppBarWidget> createState() => _BlocksAppBarWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(appBarSize);
  }
}

class _BlocksAppBarWidgetState extends State<BlocksAppBarWidget> {
  late DataStore _dataStore;
  late StepStore _stepStore;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
  }

  _buildDoneUndoneButtonStyle() {
    Task current_task = _dataStore.getTaskById(widget.taskId);
    return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor:
            current_task.isDone ? AppColors.white : AppColors.main_color,
        foregroundColor: AppColors.bright_foreground_color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        side: BorderSide(color: AppColors.white, width: 1.5));
  }

  Widget _buildButton({required ButtonStyle? buttonStyle, IconData? icon}) {
    Task current_task = _dataStore.getTaskById(widget.taskId);
    return ElevatedButton(
        onPressed: () {
          setState(() {
            // bool doneStateFlag = current_task.isDone;
            current_task.isDone = !current_task.isDone;
            _dataStore.updateTask(current_task).then((_) {
              _dataStore.getTasks(_stepStore.currentStep).then((_) {
                _dataStore.getAllTasks().then((_) {
                  print("firsssssssssssssssssssssst");
                  _dataStore.completionPercentages();
                });
                // setState(() {
                // });
              });
            });
          });
        },
        style: buttonStyle,
        child: Icon(
          icon,
          color: AppColors.main_color,
        ));
  }

  Widget _buildDoneUnDoneButton() {
    Task current_task = _dataStore.getTaskById(widget.taskId);
    return _buildButton(
      buttonStyle: _buildDoneUndoneButtonStyle(),
      icon: current_task.isDone ? Icons.done_rounded : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TaskList(currentStepNo: _stepStore.currentStep - 1),
            ),
          );
        },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors.bright_foreground_color,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScrollingOverflowText(
            text: widget.title,
            textStyle: TextStyle(
              color: AppColors.bright_foreground_color,
              fontSize: 20,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: Dimens.doneButtonPadding,
            child: Container(
                height: 25, width: 25, child: _buildDoneUnDoneButton()),
          ),
        ],
      ),
    );
  }
}
