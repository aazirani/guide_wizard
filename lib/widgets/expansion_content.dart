import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/url_handler.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:render_metrics/render_metrics.dart';

class ExpansionContent extends StatefulWidget {
  String markdown;
  String? deadline;

  ExpansionContent({
    Key? key,
    required this.renderManager,
    required this.markdown,
    this.deadline,
  }) : super(key: key);

  final RenderParametersManager renderManager;

  // final ChromeSafariBrowser browser = AppChromeSafariBrowser();

  @override
  State<ExpansionContent> createState() => _ExpansionContentState();
}

class _ExpansionContentState extends State<ExpansionContent> {
  double widgetHeight = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: Dimens.expansionContentPadding,
            child: MeasureSize(
                onChange: (Size size) {
                  setState(() {
                    widgetHeight = size.height;
                  });
                },
                child: Column(
                    children: [
                      if (widget.deadline != null) _buildDeadlineContainer(),
                      _buildMarkdownContent()
                    ])),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineContainer() {
    return Padding(
        padding: Dimens.deadlineContainerPadding,
        child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.red[250]!.withOpacity(Dimens.deadlineContainerColorOpacity),
                  border: Border(
                      left: BorderSide(width: Dimens.deadlineContainerBorderWidth, color: AppColors.red[150]!))),
              child: Padding(
                padding: Dimens.deadlineContentPadding,
                child: Text("${widget.deadline}",
                    style: TextStyle(
                        color: AppColors.red[200],
                        fontWeight: FontWeight.w800)),
              ),
            )));
  }

  Widget _buildMarkdownContent() {
    return Markdown(
      onTapLink: (text, url, title) {
        UrlHandler.openUrl(context: context, url: url!);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      data: fixedJsonMarkdown(widget.markdown));
  }

  String fixedJsonMarkdown(String json_markdown) {
    return json_markdown.replaceAllMapped(RegExp(r'(?<!\\)\\n'), (match) {
      return '\n';
    });
  }
}
