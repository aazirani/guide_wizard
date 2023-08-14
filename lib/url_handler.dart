import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/lang_keys.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:flutter/material.dart';
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
    ButtonStyle _textButtonStyle() {
      return ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) => AppColors.main_color.withOpacity(0.13)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate(LangKeys.url_dialog_title),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context).translate(LangKeys.url_dialog_message) + " $url?",
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context).translate(LangKeys.cancel), style: TextStyle(color: AppColors.main_color),),
            style: _textButtonStyle(),
          ),
          TextButton(
              onPressed: () {
                _launchURL(url);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate(LangKeys.open_link), style: TextStyle(color: AppColors.main_color),),
              style: _textButtonStyle(),
          ),
        ],
      ),
    );
  }
}