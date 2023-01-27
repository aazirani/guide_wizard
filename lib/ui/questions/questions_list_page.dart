import 'dart:math';

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'question_widget.dart';

class QuestionsListPage extends StatefulWidget {
  QuestionList questionList;
  QuestionsListPage({Key? key, required this.questionList}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  late final itemScrollController;

  @override
  void initState() {
    itemScrollController = ItemScrollController();
    super.initState();
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/appbar_logo.png',
            fit: BoxFit.cover,
            height: Dimens.appBar["logoHeight"],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(int index) {
    return QuestionWidget(
      index: index,
      itemScrollController: itemScrollController,
      question: widget.questionList.elementAt(index),
      isLastQuestion: index == widget.questionList.length - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ScrollablePositionedList.builder(
        itemCount: widget.questionList.length,
        itemBuilder: (context, index) => _buildQuestionWidget(index),
        itemScrollController: itemScrollController,
      ),
    );
  }
}
