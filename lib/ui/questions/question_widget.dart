import 'dart:math' as math;

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/models/question/image_questions.dart';
import 'package:boilerplate/models/question/question_test.dart';
import 'package:boilerplate/models/question/text_question.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuestionWidget extends StatefulWidget {
  QuestionTest question;
  bool expanded, isLastQuestion;
  int index;
  ItemScrollController itemScrollController;

  QuestionWidget(
      {Key? key,
      required this.index,
      required this.itemScrollController,
      required this.question,
      required this.expanded,
      required this.isLastQuestion,
      })
      : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  Future scrollToItem(int index) async{
    widget.itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 700),
    );
  }

  @override
  Widget build(BuildContext context) {

    ButtonStyle _buildQuestionsButtonStyle(Color color){
      return ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(math.max(_getScreenWidth()-Dimens.buildQuestionsButtonStyle["pixels_smaller_than_screen_width"]!, 0),Dimens.buildQuestionsButtonStyle["height"]!)),
        backgroundColor: MaterialStateProperty.all<Color>(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
    }

    Widget _buildNextStageButton() {
      return Padding(
        padding: Dimens.questionButtonPadding,
        child: TextButton(
          style: _buildQuestionsButtonStyle(Colors.green.shade600),
          onPressed: () {  },
          child: Text(
              AppLocalizations.of(context).translate('next_stage_button_text'),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    }

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
            color: AppColors.main_color,
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

    Widget _buildImageOptionSubtitle(int index){
      if(widget.question.options.elementAt(index)["subtitle"]!=null){
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Transform.scale(
                child: SizedBox(
                  child: Checkbox(
                    value: widget.question.options.elementAt(index)["selected"],
                    onChanged: (value){
                      setState(() {
                        widget.question.options.elementAt(index)["selected"]=value;
                      });
                    },
                    checkColor: Colors.white,
                    activeColor: Colors.black87,
                    shape: CircleBorder(),
                  ),
                  height: 30,
                  width: 30,
                ),
                scale: 0.8,
              ),
              Flexible(
                  child: Text(
                    widget.question.options.elementAt(index)["subtitle"],
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
              ),
            ],
          ),
        );
      }
      else{
        return SizedBox();
      }
    }


    Widget _buildImageCheckBox(int index){
      if(widget.question.options.elementAt(index)["subtitle"]==null)
        return Checkbox(
          value: widget.question.options.elementAt(index)["selected"],
          onChanged: (value){
            setState(() {
              widget.question.options.elementAt(index)["selected"]=value;
            });
          },
          checkColor: Colors.white,
          activeColor: Colors.black87,
          shape: CircleBorder(),
          side: BorderSide(color: Colors.transparent),
        );
      return SizedBox();
    }

    Widget _buildSingleImageOption(int index){
      ImageQuestion imageQuestion=widget.question as ImageQuestion;
      return Flexible(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
            margin: const EdgeInsets.all(8),
            height: imageQuestion.height,
              width: imageQuestion.width,
              child: ListTile(
                onTap: (){
                  setState(() {
                    imageQuestion.options.elementAt(index)["selected"] =! imageQuestion.options.elementAt(index)["selected"];
                  });
                },
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: imageQuestion.options.elementAt(index)["selected"] ? Colors.black:Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                // checkboxShape: CircleBorder(),
                title: Column(
                  children: [
                    imageQuestion.options.elementAt(index)["image"],
                    _buildImageOptionSubtitle(index),
                  ],
                ),
                tileColor: AppColors.grey,
              ),
            ),
            _buildImageCheckBox(index),
          ],
        ),
      );
    }

    Widget _buildAImageOptionsRow(int begin, int end){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(int index=begin; index<end; index++)
              _buildSingleImageOption(index),
          ],
        ),
      );
    }

    Widget _buildImageOptions(){
      ImageQuestion imageQuestion=widget.question as ImageQuestion;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(int row=0; row<=imageQuestion.options.length/imageQuestion.columns; row++)
            _buildAImageOptionsRow(row*imageQuestion.columns, math.min((row+1)*imageQuestion.columns, imageQuestion.options.length)),
        ],
      );
    }

    Widget _buildOptions(){
      switch(widget.question.runtimeType){
        case TextQuestion:
          return _buildTextOptions();
        case ImageQuestion:
          return _buildImageOptions();
        default:
          return SizedBox();
      }
    }


    Widget _buildNextQuestionButton() {
      return Padding(
        padding: Dimens.questionButtonPadding,
        child: TextButton(
          style: _buildQuestionsButtonStyle(AppColors.main_color),
          onPressed: () {
            scrollToItem(widget.index+1);
          },
          child: Text(
            AppLocalizations.of(context).translate('next_question_button_text'),
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      );
    }

    Widget _buildDescription(){
      return Container(
        margin: Dimens.questionDescriptionPadding,
        child: Text(
          widget.question.description,
        ),
      );
    }

    return Card(
      child: ListTileTheme(
        contentPadding: Dimens.listTilePadding,
        dense: false,
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: ExpansionTile(
          tilePadding: Dimens.listTilePadding,
          textColor: AppColors.main_color,
          iconColor: AppColors.main_color,
          initiallyExpanded: widget.expanded,
          title: _buildTitle(),
          controlAffinity: ListTileControlAffinity.leading,

          children: <Widget>[
            _buildDescription(),
            _buildOptions(),
            widget.isLastQuestion ? _buildNextStageButton():_buildNextQuestionButton(),
          ],
        ),
      ),
    );
  }
}
