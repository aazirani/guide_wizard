import 'package:flutter/material.dart';

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
            minimumSize: MaterialStateProperty.all(Size(_getScreenWidth()-26,60)),
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(0, 81, 158, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
        ),
        onPressed: () {  },
        child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 15),),
      );
    }

    return Scaffold(
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
                  headerBuilder: (BuildContext, isExpanded)=>Text("test"),
                  body: Text("test"),
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
