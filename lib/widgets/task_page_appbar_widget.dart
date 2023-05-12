import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';

class BlocksAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  bool isDone;
  double appBarSize;
  String title;
  BlocksAppBarWidget(
      {Key? key,
      required this.isDone,
      required this.appBarSize,
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
  _buildDoneButtonStyle() {
    return ElevatedButton.styleFrom(
        // overlayColor: MaterialStateProperty.all<Color>(AppColors.bright_foreground_color.withOpacity(0.1)),
        backgroundColor: AppColors.main_color,
        foregroundColor: AppColors.bright_foreground_color.withOpacity(0.1),
        // disabledBackgroundColor: Colors.red,
        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
        //     )
        // )
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        side: BorderSide(color: AppColors.white, width: 2));
  }

  _buildUndoneButtonStyle() {
    // return ButtonStyle(
    //     overlayColor: MaterialStateProperty.all<Color>(AppColors.bright_foreground_color.withOpacity(0.1)),
    //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //         RoundedRectangleBorder(
    //             borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
    //             side: BorderSide(color: AppColors.bright_foreground_color)
    //         )
    //     )
    // );
    return ElevatedButton.styleFrom(
        // overlayColor: MaterialStateProperty.all<Color>(AppColors.bright_foreground_color.withOpacity(0.1)),
        padding: EdgeInsets.all(0),
        // backgroundColor: AppColors.button_background_color,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.bright_foreground_color.withOpacity(0.1),
        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
        //     )
        // )
        // shape: CircleBorder(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        side: BorderSide(color: AppColors.white, width: 1.2));
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

  Widget _buildDoneButton() {
    return _buildButton(
      buttonStyle: _buildDoneButtonStyle(),
      // text: AppLocalizations.of(context).translate('done_button_text'),
      // icon: Icons.done_rounded
    );
  }

  Widget _buildUndoneButton() {
    return _buildButton(
      buttonStyle: _buildUndoneButtonStyle(),
      icon: Icons.done_rounded,
    );
  }

  Widget _buildDoneUnDoneButton() {
    return widget.isDone ? _buildUndoneButton() : _buildDoneButton();
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
            padding: const EdgeInsets.only(right: 20, left: 10, top: 10),
            child: Container(
                height: 25, width: 25, child: _buildDoneUnDoneButton()),
          ),
        ],
      ),
    );
  }
}
