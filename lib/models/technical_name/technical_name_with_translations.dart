import 'package:guide_wizard/models/translation/translation.dart';

class TechnicalNameWithTranslations {
  int id;
  String technical_name;
  int creator_id;
  String created_at;
  String updated_at;
  List<Translation> translations;

  TechnicalNameWithTranslations({
    required this.id,
    required this.technical_name,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
    required this.translations,
  });

  factory TechnicalNameWithTranslations.fromMap(Map<String, dynamic> json) {
    return TechnicalNameWithTranslations(
      id: json["id"],
      technical_name: json["technical_name"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
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
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
      "translations":
          translations.map((translation) => translation.toMap()).toList(),
    };
  }

  get technicalName {
    return technical_name;
  }
}
