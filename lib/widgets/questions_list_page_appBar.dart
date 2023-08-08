import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';

class QuestionsListAppBar extends StatefulWidget implements PreferredSizeWidget {
  double appBarSize;
  double fontSize;
  String title;

  QuestionsListAppBar(
      {Key? key,
        this.appBarSize = Dimens.questionListPageAppBarHeight,
        this.fontSize = Dimens.questionListPageAppBarFontSize,
        required this.title,
      })
      : super(key: key);

  @override
  State<QuestionsListAppBar> createState() => _QuestionsListAppBarState();

  @override
  Size get preferredSize {
    return Size.fromHeight(appBarSize);
  }
}

class _QuestionsListAppBarState extends State<QuestionsListAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      leading: IconButton(
        onPressed: () {
          DataLoadHandler(context: context).checkIfUpdateIsNecessary();
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: AppColors.bright_foreground_color,
        ),
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: AppColors.white, fontSize: 20),
      ),
    );
  }

}
