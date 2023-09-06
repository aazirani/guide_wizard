import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/widgets_constants/scrolling_overflow_text_constants.dart';
import 'package:marquee/marquee.dart';

class ScrollingOverflowText extends StatefulWidget {
  String text;
  TextStyle? style;
  double height, overflowRatio;
  double? width;

  ScrollingOverflowText(this.text,
      {Key? key,
      this.style,
      this.height = ScrollingOverflowTextConstants.defaultHeight,
      this.width,
      this.overflowRatio = ScrollingOverflowTextConstants.defaultOverflowRatio})
      : super(key: key);

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
          style: widget.style,
        );
        final painter = TextPainter(
          text: span,
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        );
        painter.layout();
        final overflow = painter.size.width > constraints.maxWidth ||
            painter.size.width > _getScreenWidth() * widget.overflowRatio;
        return overflow
            ? getScrollingText()
            : Text(
                widget.text,
                style: widget.style,
              );
      },
    );
  }

  Widget getScrollingText() {
    return Container(
      height: widget.height,
      width: widget.width ?? _getScreenWidth() * widget.overflowRatio,
      child: Marquee(
        text: widget.text,
        style: widget.style,
        showFadingOnlyWhenScrolling:
            ScrollingOverflowTextConstants.showFadingOnlyWhenScrolling,
        startAfter: ScrollingOverflowTextConstants.startAfter,
        pauseAfterRound: ScrollingOverflowTextConstants.pauseAfterRound,
        fadingEdgeEndFraction:
            ScrollingOverflowTextConstants.fadingEdgeEndFraction,
        blankSpace: ScrollingOverflowTextConstants.blankSpace,
        velocity: ScrollingOverflowTextConstants.velocity,
      ),
    );
  }
}
