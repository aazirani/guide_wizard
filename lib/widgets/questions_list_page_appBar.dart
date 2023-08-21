import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/data/data_laod_handler.dart';
import 'package:guide_wizard/widgets/scrolling_overflow_text.dart';

class QuestionsListAppBar extends StatefulWidget implements PreferredSizeWidget {
  double appBarSize;
  double fontSize;
  String title;

  QuestionsListAppBar(
      {Key? key,
        this.appBarSize = Dimens.questionListPageAppBarHeight,
        this.fontSize = Dimens.questionListPageAppBarFontSize,
        this.title = "",
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
      title: ScrollingOverflowText(
        widget.title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppColors.white),
        overflowRatio: 0.75,
      ),
    );
  }

}
