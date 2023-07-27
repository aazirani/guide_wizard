import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class ScrollingOverflowText extends StatefulWidget {
  String text;
  TextStyle? textStyle;
  double height, velocity;
  double? width;
  ScrollingOverflowText({Key? key, required this.text, this.textStyle, this.height = 30, this.width, this.velocity = 30}) : super(key: key);

  @override
  State<ScrollingOverflowText> createState() => _ScrollingOverflowTextState();
}

class _ScrollingOverflowTextState extends State<ScrollingOverflowText> {
  double _getScreenWidth() => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: widget.text,
          style: widget.textStyle,
        );
        final painter = TextPainter(
          text: span,
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.ltr,
        );
        painter.layout();
        final overflow = painter.size.width > constraints.maxWidth || painter.size.width > _getScreenWidth() * 0.7;
        return overflow ? getScrollingText() : Text(widget.text, style: widget.textStyle,);
      },
    );
  }

  Widget getScrollingText() {
    return Container(
      height: widget.height,
      width: widget.width ?? _getScreenWidth() * 0.75,
      child: Marquee(
        text: widget.text,
        style: widget.textStyle,
        showFadingOnlyWhenScrolling: false,
        startAfter: Duration(seconds: 5),
        pauseAfterRound: Duration(seconds: 3),
        fadingEdgeEndFraction: 0.3,
        blankSpace: 100,
        velocity: 40,
      ),
    );
  }
}
