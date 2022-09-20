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
    );
  }
}
