import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;
import '../../models/question/image_questions.dart';
import '../../models/question/question.dart';
import '../../models/question/text_question.dart';
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
  late List<Question> questions;
  final itemScrollController = ItemScrollController();

  @override
  void initState() {
    expanded=true;
    // _controller = ExpandedTileController(isExpanded:true);
    questions=[
      TextQuestion(
          title: "Question Title",
          description: "description description description description description description description",
          options: [
            {"title": "option1", "selected":false},
            {"title": "option2", "selected":false},
            {"title": "option3", "selected":false},
          ],
          multiChoice: true,
      ),
      TextQuestion(
          title: "What is up?",
          description: "description description description description description description description",
          options: [
            {"title": "option1", "selected":false},
            {"title": "option2", "selected":false},
            {"title": "option3", "selected":false},
          ],
          multiChoice: true,
      ),
      ImageQuestion(
        title: "Image with subtitle",
        description: "description description description description description description description",
        options: [
          {"image": Image.asset("assets/images/test_image.jpg"), "subtitle":"image subtitle!", "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "subtitle":"image subtitle!", "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "subtitle":"image subtitle!", "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "subtitle":"image subtitle!", "selected":false},
        ],
        multiChoice: true,
        columns: 2,
        // height: 150,
        // width: 150,
      ),
      ImageQuestion(
        title: "Image without subtitle!",
        description: "description description description description description description description",
        options: [
          {"image": Image.asset("assets/images/test_image.jpg"), "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "selected":false},
          {"image": Image.asset("assets/images/test_image.jpg"), "selected":false},
        ],
        multiChoice: true,
        columns: 2,
        // height: 150,
        // width: 150,
      ),
    ];
    super.initState();
  }

  double _getScreenWidth()=>MediaQuery.of(context).size.width;






  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.hannover_blue,
      toolbarHeight: 70,
      titleSpacing: 5,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/honnover_uni_logo.png',
            fit: BoxFit.cover,
            height: 60,
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
    return QuestionWidget(
      index: index,
      itemScrollController: itemScrollController,
      question: questions[index],
      expanded: false,
      isLastQuestion: index==questions.length-1
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ScrollablePositionedList.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) => _buildQuestionWidget(index),
        itemScrollController: itemScrollController,
      ),
      // floatingActionButton: _buildNextStageButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
