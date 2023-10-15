import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'dart:js' as js;

class UrlHandler {
  UrlHandler._();

  static _launchURL(String urlAddress) async {
    js.context.callMethod('open', [urlAddress]);
  }

  static openUrl(
      {required BuildContext context,
      required String url,
      required TechnicalNameWithTranslationsStore
          technicalNameWithTranslationsStore}) {
    ButtonStyle _textButtonStyle() {
      return ButtonStyle(
        overlayColor: MaterialStateColor.resolveWith((states) =>
            context.openButtonOverlayColor),
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
        title: Text(
          technicalNameWithTranslationsStore
              .getTranslationByTechnicalName(LangKeys.url_dialog_title),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              technicalNameWithTranslationsStore.getTranslationByTechnicalName(
                      LangKeys.url_dialog_message) +
                  " $url?",
              textAlign: TextAlign.left,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              technicalNameWithTranslationsStore
                  .getTranslationByTechnicalName(LangKeys.cancel),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            style: _textButtonStyle(),
          ),
          TextButton(
            onPressed: () {
              _launchURL(url);
              Navigator.of(context).pop();
            },
            child: Text(
              technicalNameWithTranslationsStore
                  .getTranslationByTechnicalName(LangKeys.open_link),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            style: _textButtonStyle(),
          ),
        ],
      ),
    );
  }
}
