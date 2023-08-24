import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
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

  static openUrl({required BuildContext context, required String url, required TechnicalNameWithTranslationsStore technicalNameWithTranslationsStore}) {
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
        title: Text(technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.url_dialog_title),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.url_dialog_message) + " $url?",
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.cancel), style: Theme.of(context).textTheme.bodySmall,),
            style: _textButtonStyle(),
          ),
          TextButton(
              onPressed: () {
                _launchURL(url);
                Navigator.of(context).pop();
              },
              child: Text(technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.open_link), style: Theme.of(context).textTheme.bodySmall,),
              style: _textButtonStyle(),
          ),
        ],
      ),
    );
  }
}