import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHandler {
  UrlHandler._();

  // void _openURLInChromeSafari(String url) async{
  //   widget.browser.open(
  //       url: Uri.parse(url),
  //   options: ChromeSafariBrowserClassOptions(
  //   android: AndroidChromeCustomTabsOptions(
  //   shareState: CustomTabsShareState.SHARE_STATE_OFF),
  //   ios: IOSSafariOptions(barCollapsingEnabled: true)));
  // }

  static Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
    }
  }

  static _launchURL(String urlAddress) async {
    final Uri url = Uri.parse(urlAddress);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  static openUrl({required BuildContext context, required String url}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Open URL"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Do you want to open $url?",
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: TextStyle(color: AppColors.main_color),)
          ),
          TextButton(
              onPressed: () {
                _launchURL(url);
              },
              child: Text("Open Link", style: TextStyle(color: AppColors.main_color),)
          ),
        ],
      ),
    );
  }
}