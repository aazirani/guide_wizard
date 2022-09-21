import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;

class TextQuestion extends StatefulWidget {
  const TextQuestion({Key? key}) : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  late bool expanded;
  @override
  void initState() {
    expanded=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _getScreenWidth()=>MediaQuery.of(context).size.width;

    Widget _buildFloatingActionButton() {
      return TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size(math.max(_getScreenWidth()-26, 0),55)),
            backgroundColor: MaterialStateProperty.all<Color>(AppColors.hannover_blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
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




    Widget _buildHelpButton(){
      return Container(
        child: Material(
          child: InkWell(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Icon(Icons.question_mark_rounded, color: Colors.white,),
            ),
          ),
          color: Colors.transparent,
        ),
        decoration: BoxDecoration(
            color: AppColors.hannover_blue,
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      );
    }

    Widget _buildExpansionPanelTitle(String title, bool isExpanded){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 15,),
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            ],
          ),
          isExpanded ? _buildHelpButton():SizedBox(),
        ],
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                expanded = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                  headerBuilder: (BuildContext, isExpanded) => _buildExpansionPanelTitle("Question Title!", isExpanded),
                  body: Container(
                    color: AppColors.grey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "This is just a sample question for testing ui implementation! question can be in multiple lines and this app supports it! This is just a sample question for testing ui implementation! question can be in multiple lines and this app supports it!",
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                            child: TextButton(
                              style: ButtonStyle(
                                // backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                minimumSize: MaterialStateProperty.all(Size(math.max(_getScreenWidth(), 0), 45)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Colors.black),
                                    ),
                                ),
                              ),
                              onPressed: () {  },
                              child: Text("Next Question", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w300),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  isExpanded: expanded,
                  canTapOnHeader: true,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
