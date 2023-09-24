import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/models/step/app_step.dart';
import 'package:guide_wizard/models/task/task.dart';
import 'package:guide_wizard/stores/data/data_store.dart';
import 'package:guide_wizard/widgets/scrolling_overflow_text.dart';
import 'package:provider/provider.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class BlocksAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  Task task;
  AppStep step;
  double appBarSize = Dimens.taskPage.blocksAppBarWidgetHeight;
  String title;
  BlocksAppBarWidget(
      {Key? key,
        required this.task,
        required this.title,
        required this.step})
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dataStore = Provider.of<DataStore>(context);
  }

  _buildDoneUndoneButtonStyle() {
    return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor: widget.task.isDone ? context.lightBackgroundColor : context.primaryColor,
        foregroundColor: context.doneButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(Dimens.taskPageAppBarWidget.doneUndoneButtonBorderRadius),
        ),
        side: BorderSide(color: context.lightBackgroundColor, width: 1.5));
  }

  Widget _buildButton({required ButtonStyle? buttonStyle, IconData? icon}) {
    return ElevatedButton(
        onPressed: () async {
          if(!_dataStore.stepLoading){
            //widget.task.toggleDone();
            await _dataStore.toggleTask(widget.task);
          }
        },
        style: buttonStyle,
        child: Icon(
          icon,
          color: context.primaryColor,
        ));
  }

  Widget _buildDoneUnDoneButton() {
    return _buildButton(
      buttonStyle: _buildDoneUndoneButtonStyle(),
      icon: widget.task.isDone ? Icons.done_rounded : null,
    );
  }

  Widget _buildDoneUndoneButtonContainer() {
    return Container(
        height: Dimens.taskPageAppBarWidget.doneUndoneButtonHeight,
        width: Dimens.taskPageAppBarWidget.doneUndoneButtonWidth,
        child: _buildDoneUnDoneButton());
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => AppBar(
        backgroundColor: context.primaryColor,
        toolbarHeight: Dimens.appBar.toolbarHeight,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.lightBackgroundColor,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ScrollingOverflowText(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: context.textOnDarkBackgroundColor),
              overflowRatio: 0.65,
            ),
            Padding(
              padding: Dimens.taskPageAppBarWidget.doneButtonPadding,
              child: _buildDoneUndoneButtonContainer()
            ),
          ],
        ),
      ),
    );
  }
}
