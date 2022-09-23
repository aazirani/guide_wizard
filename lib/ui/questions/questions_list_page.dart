import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;
import 'text_question.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class QuestionsListPage extends StatefulWidget {
  const QuestionsListPage({Key? key}) : super(key: key);

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {

  late bool expanded;
  late ExpandedTileController _controller;

  @override
  void initState() {
    expanded=true;
    _controller = ExpandedTileController(isExpanded:true);
    super.initState();
  }

  double _getScreenWidth()=>MediaQuery.of(context).size.width;

  Widget _buildFloatingActionButton() {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(math.max(_getScreenWidth()-26, 0),55)),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.hannover_blue),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          TextQuestion(title: "Title", description: "description description description description description description description", options: ["Option1", "Option2", "Option3", "Option4", "Option5", "Option6"], expanded: true, multiChoice: false),
          TextQuestion(title: "Title", description: "description description description description description description description", options: [], expanded: true, multiChoice: false),
          SizedBox(height: 80,),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
