import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/widgets_constants/scrolling_overflow_text_constants.dart';
import 'package:guide_wizard/stores/app_settings/app_settings_store.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class ScrollingOverflowText extends StatefulWidget {
  String text;
  TextStyle? style;
  double height, overflowRatio;
  double? width;
  ScrollingOverflowText(this.text, {Key? key, this.style, this.height = ScrollingOverflowTextConstants.defaultHeight, this.width, this.overflowRatio = ScrollingOverflowTextConstants.defaultOverflowRatio}) : super(key: key);

  @override
  State<ScrollingOverflowText> createState() => _ScrollingOverflowTextState();
}

class _ScrollingOverflowTextState extends State<ScrollingOverflowText> {
  late AppSettingsStore _appSettingsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _appSettingsStore = Provider.of<AppSettingsStore>(context);
  }

  double _getScreenWidth() => kIsWeb ? _appSettingsStore.currentMinDimension : MediaQuery.of(context).size.width;

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
        final overflow = painter.size.width > constraints.maxWidth || painter.size.width > _getScreenWidth() * widget.overflowRatio;
        return overflow ? getScrollingText() : Text(widget.text, style: widget.style,);
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
        showFadingOnlyWhenScrolling: ScrollingOverflowTextConstants.showFadingOnlyWhenScrolling,
        startAfter: ScrollingOverflowTextConstants.startAfter,
        pauseAfterRound: ScrollingOverflowTextConstants.pauseAfterRound,
        fadingEdgeEndFraction: ScrollingOverflowTextConstants.fadingEdgeEndFraction,
        blankSpace: ScrollingOverflowTextConstants.blankSpace,
        velocity: ScrollingOverflowTextConstants.velocity,
      ),
    );
  }
}
