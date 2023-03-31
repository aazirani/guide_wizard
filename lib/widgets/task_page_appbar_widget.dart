import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/scrolling_overflow_text.dart';
import 'package:flutter/material.dart';

class BlocksAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  bool isDone;
  double appBarSize;
  String title;
  BlocksAppBarWidget({Key? key, required this.isDone, required this.appBarSize, required this.title}) : super(key: key);

  @override
  State<BlocksAppBarWidget> createState() => _BlocksAppBarWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(appBarSize);
  }
}

class _BlocksAppBarWidgetState extends State<BlocksAppBarWidget> {

  _buildDoneButtonStyle(){
    return ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(AppColors.bright_foreground_color.withOpacity(0.1)),
        backgroundColor: MaterialStateProperty.all<Color>(
            AppColors.button_background_color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
            )
        )
    );
  }

  _buildUndoneButtonStyle(){
    return ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(AppColors.bright_foreground_color.withOpacity(0.1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
                side: BorderSide(color: AppColors.bright_foreground_color)
            )
        )
    );
  }

  Widget _buildButton({required ButtonStyle? buttonStyle, required String text, required IconData? icon}) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isDone = !widget.isDone;
        });
      },
      style: buttonStyle,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: AppColors.bright_foreground_color,
              ),
            ),
            SizedBox(width: 3,),
            Icon(icon, color: AppColors.bright_foreground_color),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return _buildButton(
      buttonStyle: _buildDoneButtonStyle(),
      text: AppLocalizations.of(context).translate('done_button_text'),
      icon: Icons.done_rounded
    );
  }

  Widget _buildUndoneButton() {
    return _buildButton(
        buttonStyle: _buildUndoneButtonStyle(),
        text: AppLocalizations.of(context).translate('undone_button_text'),
        icon: Icons.close_rounded,
    );
  }

  Widget _buildAppBarButton(){
    return widget.isDone ? _buildUndoneButton():_buildDoneButton();
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
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.bright_foreground_color,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScrollingOverflowText(
            text: widget.title,
            textStyle: TextStyle(
              color: AppColors.bright_foreground_color,
              fontSize: 22,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 10),
            child: _buildAppBarButton(),
          ),
        ],
      ),
    );
  }
}
