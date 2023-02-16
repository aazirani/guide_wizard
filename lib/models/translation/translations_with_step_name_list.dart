import 'package:boilerplate/models/translation/translation.dart';
import 'package:boilerplate/models/translation/translations_with_step_name.dart';

class TranslationsWithStepNameList {
  List<TranslationsWithStepName> translationsWithStepName;

  TranslationsWithStepNameList({
    required this.translationsWithStepName,
  });

  factory TranslationsWithStepNameList.fromJson(List<dynamic> json) {
    return TranslationsWithStepNameList(
      translationsWithStepName: json.map((translationsWithStepName) => TranslationsWithStepName.fromMap(translationsWithStepName)).toList(),
    );
  }
}