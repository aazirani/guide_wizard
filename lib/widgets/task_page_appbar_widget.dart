import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/stores/step/step_store.dart';
import 'package:guide_wizard/widgets/scrolling_overflow_text.dart';
import 'package:provider/provider.dart';

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
  late AppSettingsStore _appSettingsStore;

  bool _showDoneButtonFlag() => _stepStore.currentStep - 1 == _appSettingsStore.currentStepNumber;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
    _stepStore = Provider.of<StepStore>(context);
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  _buildDoneUndoneButtonStyle() {
    Task current_task = _dataStore.getTaskById(widget.taskId);
    return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor:
            current_task.isDone ? AppColors.white : AppColors.main_color,
        foregroundColor: AppColors.bright_foreground_color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(Dimens.doneUndoneButtonBorderRadius),
        ),
        side: BorderSide(color: AppColors.white, width: 1.5));
  }

  Widget _buildButton({required ButtonStyle? buttonStyle, IconData? icon}) {
    Task currentTask = _dataStore.getTaskById(widget.taskId);
    int stepId = _dataStore.getStepId(_stepStore.currentStep - 1);
    return ElevatedButton(
        onPressed: () {
          setState(() {
            currentTask.isDone = !currentTask.isDone;
            _dataStore.updateTask(currentTask).then((_) {
              _dataStore.getTasks(stepId).then((_) {
                _dataStore.getAllTasks().then((_) {
                  _dataStore.completionPercentages();
                });
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

  Widget _buildDoneUndoneButtonContainer() {
    return Container(
        height: Dimens.doneUndoneButtonHeight,
        width: Dimens.doneUndoneButtonWidth,
        child: _buildDoneUnDoneButton());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
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
            widget.title,
            style: TextStyle(
              color: AppColors.bright_foreground_color,
              fontSize: Dimens.taskTitleFont,
            ),
            overflowRatio: _showDoneButtonFlag() ? 0.7 : 0.73,
          ),
          Padding(
            padding: Dimens.doneButtonPadding,
            child: _showDoneButtonFlag()
                ? _buildDoneUndoneButtonContainer()
                : null,
          ),
        ],
      ),
    );
  }
}
