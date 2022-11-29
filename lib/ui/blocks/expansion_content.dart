import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/widgets/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:boilerplate/widgets/measure_size.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ExpansionContent extends StatefulWidget {
  ExpansionContent({
    Key? key,
    required this.renderManager,
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
        Padding(
          padding: Dimens.expansionDottedLinePadding,
          child: DottedLine(
            dashLength: 15,
            dashGapLength: 15,
            lineThickness: 7,
            dashColor: Colors.green,
            direction: Axis.vertical,
            lineLength: widgetHeight,
          ),
        ),
        Flexible(
          child: Padding(
            padding: Dimens.expansionContentPadding,
            child: MeasureSize(onChange: (Size size) {
              setState(() {
                widgetHeight = size.height;
              });
            },
            child: _buildMarkdownExample()),
          ),
        ),
      ],
    );
  }

  // void _openURLInChromeSafari(String url) async{
  //   widget.browser.open(
  //       url: Uri.parse(url),
  //   options: ChromeSafariBrowserClassOptions(
  //   android: AndroidChromeCustomTabsOptions(
  //   shareState: CustomTabsShareState.SHARE_STATE_OFF),
  //   ios: IOSSafariOptions(barCollapsingEnabled: true)));
  // }

  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildMarkdownExample(){ //Just for test
    return FutureBuilder(
      future: rootBundle.loadString("assets/markdown_test.md"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Markdown(
            onTapLink: (text, url, title){
              _launchInWebViewOrVC(Uri.parse(url!));
            },
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            data: snapshot.data!
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      });
  }
}