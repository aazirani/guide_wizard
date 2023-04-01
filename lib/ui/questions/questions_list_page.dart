import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/question/questions_store.dart';
import 'package:boilerplate/widgets/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuestionsListPage extends StatefulWidget {
  QuestionsListPage({Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  late final itemScrollController;
  // stores:--------------------------------------------------------------------
  late QuestionsStore _questionsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _questionsStore = Provider.of<QuestionsStore>(context);
  }

  @override
  void initState() {
    itemScrollController = ItemScrollController();
    super.initState();
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.bright_foreground_color,
        ),
      ),
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
      question: _questionsStore.questionList!.elementAt(index),
      isLastQuestion: index == _questionsStore.questionList!.length - 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ScrollablePositionedList.builder(
        itemCount: _questionsStore.questionList!.length,
        itemBuilder: (context, index) => _buildQuestionWidget(index),
        itemScrollController: itemScrollController,
      ),
    );
  }
}
