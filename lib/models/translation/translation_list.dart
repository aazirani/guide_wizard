import 'package:guide_wizard/models/translation/translation.dart' as t;

class TranslationList {
  final List<t.Translation> translations;

  TranslationList({
    required this.translations,
  });

  factory TranslationList.fromJson(List<dynamic> json) {
    List<t.Translation> translations;
    translations = json.map((translation) => t.Translation.fromMap(translation)).toList();

    return TranslationList(
      translations: translations,
    );
  }
}
