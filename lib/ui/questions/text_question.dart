import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class TextQuestion extends StatefulWidget{
  String title, description;
  List<String> options;
  bool multiChoice, expanded;
  TextQuestion({Key? key,required this.title, required this.description,required this.options, required this.expanded, required this.multiChoice}) : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {

  double _getScreenWidth()=>MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    Widget _buildHelpButton(){
      return Container(
        child: Material(
          child: InkWell(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.all(12),
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

    Widget _buildTitle(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 15,),
              Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            ],
          ),
          // widget.expanded ? _buildHelpButton():SizedBox(),
          _buildHelpButton(),
        ],
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
            Row(
              children: [
                Flexible(child: Text(widget.description,)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
