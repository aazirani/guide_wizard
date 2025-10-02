import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:guide_wizard/url_handler.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:provider/provider.dart';
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
  // stores:--------------------------------------------------------------------
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _technicalNameWithTranslationsStore =
        Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: Dimens.expansionContent.padding,
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
                ],
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineContainer() {
    return Padding(
        padding: Dimens.expansionContent.deadlineContainerPadding,
        child: Container(
          decoration: BoxDecoration(
              color: context.deadlineContainerColor,
              ),
          child: Padding(
              padding: Dimens.expansionContent.deadlineContentPadding,
              child: Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: Padding(
                          padding: EdgeInsetsDirectional.only(end: 8),
                          child: Icon(
                            Icons.calendar_month,
                            color: context.deadlineColor,
                          )),
                    ),
                    TextSpan(
                        text: "${widget.deadline}",
                        style: Theme.of(context).textTheme.bodyMedium,),
                  ],
                ),
              )),
        ));
  }

  Widget _buildMarkdownContent() {
    return Markdown(
      onTapLink: (text, url, title) {
        UrlHandler.openUrl(
            context: context,
            url: url!,
            technicalNameWithTranslationsStore:
                _technicalNameWithTranslationsStore);
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      data: fixedJsonMarkdown(widget.markdown),
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: BoxDecoration(
          color: context.blockQuoteColor,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
          p: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: context.textOnLightBackgroundColor)),
    );
  }

  String fixedJsonMarkdown(String json_markdown) {
    return json_markdown.replaceAll('\\n', '\n');
  }
}
