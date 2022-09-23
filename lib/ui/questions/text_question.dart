import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'dart:math' as math;
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';

class TextQuestion extends StatefulWidget {
  String title, description;
  List<String> options;
  bool multiChoice, expanded;

  TextQuestion(
      {Key? key,
      required this.title,
      required this.description,
      required this.options,
      required this.expanded,
      required this.multiChoice})
      : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  late List<Map<String, dynamic>> _options_data=widget.options.map((e) => {"title":e, "value":false}).toList();

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
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // widget.expanded ? _buildHelpButton():SizedBox(),
          _buildHelpButton(),
        ],
      );
    }

    Widget _buildOptionsList(){
      return Column(
        children: _options_data.map((option) =>
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: CheckboxListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: option["value"] ? Colors.black:Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                checkboxShape: CircleBorder(),
                value: option["value"],
                onChanged: (value) {
                  setState(() {
                    _options_data.elementAt(_options_data.indexOf(option))["value"]=value;
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
          widget.description,
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
            _buildOptionsList(),
            _buildNextQuestionButton(),
          ],
        ),
      ),
    );
  }
}
