import 'package:boilerplate/models/translation/translation.dart';

class TechnicalNameWithTranslations {
  int id;
  String technical_name;
  List<Translation> translations;

  TechnicalNameWithTranslations({
    required this.id,
    required this.technical_name,
    required this.translations,
  });

  factory TechnicalNameWithTranslations.fromMap(Map<String, dynamic> json) {
    return TechnicalNameWithTranslations(
      id: json["id"],
      technical_name: json["technical_name"],
      translations: json["translations"]
          .map((translation) => Translation.fromMap(translation))
          .toList()
          .cast<Translation>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "technical_name": technical_name,
      "translations":
          translations.map((translation) => translation.toMap()).toList(),
    };
  }

  get technicalName {
    return technical_name;
  }
}
