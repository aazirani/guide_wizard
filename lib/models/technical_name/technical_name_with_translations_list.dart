import 'package:guide_wizard/models/technical_name/technical_name_with_translations.dart';

class TechnicalNameWithTranslationsList {
  List<TechnicalNameWithTranslations> technicalNameWithTranslations;

  TechnicalNameWithTranslationsList({
    required this.technicalNameWithTranslations,
  });

  factory TechnicalNameWithTranslationsList.fromJson(List<dynamic> json) {
    return TechnicalNameWithTranslationsList(
      technicalNameWithTranslations: json.map((translationsWithStepName) => TechnicalNameWithTranslations.fromMap(translationsWithStepName)).toList(),
    );
  }
}