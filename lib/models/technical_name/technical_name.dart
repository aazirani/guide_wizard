import 'package:boilerplate/models/translation/translation_list.dart';

class TechnicalName {
  int id;
  String technical_name;
  // TranslationList translations;
  int creator_id;
  String created_at;
  String updated_at;

  TechnicalName({
    required this.id,
    required this.technical_name,
    // required this.translations,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  String get string {
    return technical_name;
  }

  factory TechnicalName.fromMap(Map<String, dynamic> json) {
    return TechnicalName(
      id: json["id"],
      technical_name: json["technical_name"],
      // translations: TranslationList.fromJson(json["translations"]),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "technical_name": technical_name,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };
  
  get technicalName {
    return technical_name;
  }
}