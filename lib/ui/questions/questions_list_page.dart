import 'package:flutter/material.dart';
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

  late bool expanded;
  // late ExpandedTileController _controller;
  late List<Question> questions;
  final itemKey=GlobalKey();

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




  Widget _buildNextStageButton() {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(math.max(_getScreenWidth()-26, 0),55)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green.shade600.withOpacity(1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      onPressed: () {  },
      child: Text("Next Stage", style: TextStyle(color: Colors.white, fontSize: 15),),
    );
  }

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


  Future scrollToItem() async{
    await Scrollable.ensureVisible(context);
  }

  List<Widget> _buildQuestionsWidgetList(){
    List<Widget> questionsWidgets=questions.map<Widget>((question){
      return Container(
        // key: itemKey,
        child: QuestionWidget(
          question: question,
          expanded: false,
        ),
      );
    }
    ).toList();
    questionsWidgets.addAll(
      [
        SizedBox(height: 80,),
      ]
    );

    return questionsWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: _buildQuestionsWidgetList(),
      ),
      // floatingActionButton: _buildNextStageButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
