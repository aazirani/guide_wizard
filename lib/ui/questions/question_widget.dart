import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;
import '../../models/question/question.dart';
import '../../models/question/text_question.dart';

class QuestionWidget extends StatefulWidget {
  Question question;
  bool expanded;

  QuestionWidget(
      {Key? key,
      required this.question,
      required this.expanded,})
      : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    Widget _buildHelpButton() {
      return Container(
        child: Material(
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.question_mark_rounded,
                color: Colors.white,
              ),
            ),
          ),
          color: Colors.transparent,
        ),
        decoration: BoxDecoration(
            color: AppColors.hannover_blue,
            borderRadius: BorderRadius.all(Radius.circular(5))),
      );
    }

    Widget _buildTitle() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                widget.question.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // widget.expanded ? _buildHelpButton():SizedBox(),
          _buildHelpButton(),
        ],
      );
    }


    Widget _buildTextOptions(){
      return Column(
        children: widget.question.options.map((option) =>
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: CheckboxListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: option["selected"] ? Colors.black:Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                checkboxShape: CircleBorder(),
                value: option["selected"],
                onChanged: (value) {
                  setState(() {
                    widget.question.options.elementAt(widget.question.options.indexOf(option))["selected"]=value;
                  });
                },
                title: Text(option["title"]),
                controlAffinity: ListTileControlAffinity.leading,
                tileColor: AppColors.grey,
                activeColor: Colors.black,
              ),
            )
        ).toList(),
      );
    }

    Widget _buildImageOptions(){
      return Column(
        children: widget.question.options.map((option) =>
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: ListTile(
              onTap: (){
                setState(() {
                  int index=widget.question.options.indexOf(option);
                  widget.question.options.elementAt(index)["selected"]=!widget.question.options.elementAt(index)["selected"];
                });
              },
              shape: RoundedRectangleBorder(
                side: BorderSide(color: option["selected"] ? Colors.black:Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              // checkboxShape: CircleBorder(),
              title: Column(
                children: [
                  option["image"],
                  Row(
                    children: [
                      Checkbox(
                        value: widget.question.options.elementAt(widget.question.options.indexOf(option))["selected"],
                        onChanged: (value){
                          setState(() {
                            int index=widget.question.options.indexOf(option);
                            widget.question.options.elementAt(index)["selected"]=value;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.black87,
                        shape: CircleBorder(),
                      ),
                      Text(option["subtitle"]),
                    ],
                  ),
                ],
              ),
              // controlAffinity: ListTileControlAffinity.trailing,
              tileColor: AppColors.grey,
              // activeColor: Colors.black,
            ),
          )
        ).toList(),
      );
    }

    Widget _buildOptions(){
      if(widget.question.runtimeType==TextQuestion){
        return _buildTextOptions();
      }
      else{
        return _buildImageOptions();
      }
    }

    Widget _buildNextQuestionButton() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: TextButton(
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
          child: Text("Next Question", style: TextStyle(color: Colors.white, fontSize: 15),),
        ),
      );
    }

    Widget _buildDescription(){
      return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Text(
          widget.question.description,
        ),
      );
    }

    return Card(
      child: ListTileTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        dense: false,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          textColor: AppColors.hannover_blue,
          iconColor: AppColors.hannover_blue,
          initiallyExpanded: widget.expanded,
          title: _buildTitle(),
          // subtitle: Text('Trailing expansion arrow icon'),
          controlAffinity: ListTileControlAffinity.leading,

          children: <Widget>[
            _buildDescription(),
            _buildOptions(),
            _buildNextQuestionButton(),
          ],
        ),
      ),
    );
  }
}
