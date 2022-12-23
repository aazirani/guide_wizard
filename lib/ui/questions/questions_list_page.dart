import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:boilerplate/models/question/question.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'package:boilerplate/models/step/step.dart' as StepModel;
import 'package:boilerplate/models/title/title.dart';

import 'question_widget.dart';

class QuestionsListPage extends StatefulWidget {
  const QuestionsListPage({Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  double _getScreenHeight() => MediaQuery.of(context).size.height;

  late bool expanded;
  // late ExpandedTileController _controller;
  late QuestionList questions;
  final itemScrollController = ItemScrollController();

  @override
  void initState() {
    expanded=true;
    // _controller = ExpandedTileController(isExpanded:true);
    questions = QuestionList(questions: [
      for (int i = 0; i < 10; i++)
        Question(
          id: i,
          title: TechnicalName(id: 0, technical_name: "Question $i", creator_id: 1, created_at: '', updated_at: '', ),
          sub_title: TechnicalName(id: 0, technical_name: "Sub Title $i", creator_id: 1, created_at: '', updated_at: '', ),
          type: "TEXT",
          axis_count: 1,
          is_multiple_choice: false,
          info_url: TechnicalName(id: 0, technical_name: "Info URL $i", creator_id: 1, created_at: '', updated_at: '', ),
          info_description: TechnicalName(id: 0, technical_name: "Info Description $i", creator_id: 1, created_at: '', updated_at: '', ),
          answer_required: 1,
          answers_selected_by_default: false,
          creator_id: 1,
          created_at: "2021-09-01 00:00:00",
          updated_at: '2021-09-01 00:00:00',
          step: StepModel.Step(id: 0, name: TechnicalName(id: 0, technical_name: "Info URL $i", creator_id: 1, created_at: '', updated_at: '', ),
            description: TechnicalName(id: 0, technical_name: "Info URL $i", creator_id: 1, created_at: '', updated_at: '', ),
            order: 1, image: '', tasks: []),
          answers: [],
        )
    ]);
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


  // List<Widget> _buildQuestionsWidgetList(){
  //   List<Widget> questionsWidgets=questions.map<Widget>((question){
  //     return Container(
  //       // key: itemKey,
  //       child: QuestionWidget(
  //         question: question,
  //         expanded: false,
  //       ),
  //     );
  //   }
  //   ).toList();
  //   questionsWidgets.addAll(
  //     [
  //       SizedBox(height: 80,),
  //     ]
  //   );
  //
  //   return questionsWidgets;
  // }

  Widget _buildQuestionWidget(int index){
    if(index==questions.length){
      return SizedBox(height: _getScreenHeight(),);
    }
    return QuestionWidget(
      index: index,
      itemScrollController: itemScrollController,
      question: questions.elementAt(index),
      expanded: false,
      isLastQuestion: index==questions.length-1
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ScrollablePositionedList.builder(
        itemCount: questions.length+1,
        itemBuilder: (context, index) => _buildQuestionWidget(index),
        itemScrollController: itemScrollController,
      ),
      // floatingActionButton: _buildNextStageButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
