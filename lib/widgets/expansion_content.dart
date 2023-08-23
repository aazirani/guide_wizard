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
                child: Column(children: [
                  (widget.deadline!.isNotEmpty)
                      ? _buildDeadlineContainer()
                      : Container(),
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
                  color: AppColors.orange[50]!.withOpacity(0.1),
                  ),
              child: Padding(
                  padding: Dimens.deadlineContentPadding,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.calendar_month,
                                color: AppColors.orange[100],
                              )),
                        ),
                        TextSpan(
                            text: "${widget.deadline}",
                            style: TextStyle(
                                color: AppColors.orange[200],
                                )),
                      ],
                    ),
                  )),
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
