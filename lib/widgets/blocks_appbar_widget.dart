import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class BlocksAppBarWidget extends StatefulWidget {
  bool isDone;
  BlocksAppBarWidget({Key? key, required this.isDone}) : super(key: key);

  @override
  State<BlocksAppBarWidget> createState() => _BlocksAppBarWidgetState();
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

  Widget _buildButton({required ButtonStyle? buttonStyle, required String text}) {
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
            Icon(Icons.close_rounded, color: AppColors.bright_foreground_color),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton(){
    return _buildButton(
      buttonStyle: _buildDoneButtonStyle(),
      text: AppLocalizations.of(context).translate('done_button_text')
    );
  }

  Widget _buildUndoneButton(){
    return _buildButton(
        buttonStyle: _buildUndoneButtonStyle(),
        text: AppLocalizations.of(context).translate('undone_button_text')
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
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.bright_foreground_color,),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              "Private Housing",
              style: TextStyle(
                color: AppColors.bright_foreground_color,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: _buildAppBarButton(),
          ),
        ],
      ),
    );
  }
}
