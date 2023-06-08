import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';

class BlocksAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  bool isDone;
  double appBarSize;
  String title;
  BlocksAppBarWidget(
      {Key? key,
      required this.isDone,
      required this.title,
      this.appBarSize = Dimens.blocksAppBarWidgetHeight,})
      : super(key: key);

  @override
  State<BlocksAppBarWidget> createState() => _BlocksAppBarWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(appBarSize);
  }
}

class _BlocksAppBarWidgetState extends State<BlocksAppBarWidget> {

  _buildDoneUndoneButtonStyle() {
    return ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor: widget.isDone ? AppColors.white : AppColors.main_color,
        foregroundColor: AppColors.bright_foreground_color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        side: BorderSide(color: AppColors.white, width: 1.5));
  }

  Widget _buildButton({required ButtonStyle? buttonStyle, IconData? icon}) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            widget.isDone = !widget.isDone;
          });
        },
        style: buttonStyle,
        child: Icon(
          icon,
          color: AppColors.main_color,
        ));
  }

  Widget _buildDoneUnDoneButton() {
    return _buildButton(
      buttonStyle: _buildDoneUndoneButtonStyle(),
      icon: widget.isDone ? Icons.done_rounded : null, 
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
