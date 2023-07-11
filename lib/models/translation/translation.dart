import 'package:boilerplate/models/language/language.dart' as L;

class Translation {
  int id;
  int text_id;
  String translated_text;
  int language_id;
  L.Language language;
  int creator_id;
  String created_at;
  String updated_at;

  Translation({
    required this.id,
    required this.text_id,
    required this.translated_text,
    required this.language_id,
    required this.language,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Translation.fromMap(Map<String, dynamic> json) {
    return Translation(
      id: json["id"],
      text_id: json["text_id"],
      translated_text: json["translated_text"],
      language_id: json["language_id"],
      language: L.Language.fromMap(json["language"]),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text_id": text_id,
      "translated_text": translated_text,
      "language_id": language_id,
      "language": language.toMap(),
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }
}
