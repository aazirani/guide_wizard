import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/widgets/question_widget.dart';
import 'package:boilerplate/widgets/questions_list_page_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:boilerplate/stores/data/data_store.dart';

class QuestionsListPage extends StatefulWidget {
  QuestionsListPage({Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  late final itemScrollController;
  // stores:--------------------------------------------------------------------
  late DataStore _dataStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _dataStore = Provider.of<DataStore>(context);
  }

  @override
  void initState() {
    itemScrollController = ItemScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuestionsListAppBar(),
      backgroundColor: AppColors.main_color,
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ScrollablePositionedList.builder(
            itemCount: _dataStore.questionList.length,
            itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(5.0),
                child: _buildQuestionWidget(index)),
            itemScrollController: itemScrollController,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionWidget(int index) {
    return QuestionWidget(
      index: index,
      itemScrollController: itemScrollController,
      question: _dataStore.questionList.elementAt(index),
      isLastQuestion: index == _dataStore.questionList.length - 1,
    );
  }
}
