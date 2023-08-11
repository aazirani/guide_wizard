import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/url_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:render_metrics/render_metrics.dart';

class ExpansionContent extends StatefulWidget {
  String markdown;

  ExpansionContent({
    Key? key,
    required this.renderManager,
    required this.markdown,
  }) : super(key: key);

  final RenderParametersManager renderManager;

  // final ChromeSafariBrowser browser = AppChromeSafariBrowser();

  @override
  State<ExpansionContent> createState() => _ExpansionContentState();
}

class _ExpansionContentState extends State<ExpansionContent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: Dimens.expansionContentPadding,
            child: _buildMarkdownContent(),
          ),
        ),
      ],
    );
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

  String fixedJsonMarkdown(String json_markdown){
    return json_markdown.replaceAllMapped(RegExp(r'(?<!\\)\\n'), (match) {
      return '\n';
    });
  }
}
