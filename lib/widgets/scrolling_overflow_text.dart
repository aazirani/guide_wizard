import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollingOverflowText extends StatefulWidget {
  String text;
  TextStyle? textStyle;
  double height, velocity;
  double? width;
  ScrollingOverflowText({Key? key, required this.text, this.textStyle, this.height=30, this.width, this.velocity=30}) : super(key: key);

  @override
  State<ScrollingOverflowText> createState() => _ScrollingOverflowTextState();
}

class _ScrollingOverflowTextState extends State<ScrollingOverflowText> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: widget.height,
        width: widget.width ?? _getScreenWidth(),
        child: Marquee(
          text: widget.text,
          style: widget.textStyle,
          velocity: widget.velocity,
          blankSpace: 20.0,
          pauseAfterRound: Duration(milliseconds: 2000),
        ),
      ),
    );
  }
}
