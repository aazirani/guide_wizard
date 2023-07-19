import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
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
        title: Text(AppLocalizations.of(context).translate('url_dialog_title'),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).translate('url_dialog_message') + " $url?",
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate('cancel'), style: TextStyle(color: AppColors.main_color),)
          ),
          TextButton(
              onPressed: () {
                _launchURL(url);
              },
              child: Text(AppLocalizations.of(context).translate('open_link'), style: TextStyle(color: AppColors.main_color),)
          ),
        ],
      ),
    );
  }
}