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
    _launchURL(url);
  }
}
