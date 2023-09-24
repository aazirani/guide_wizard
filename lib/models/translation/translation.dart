import 'package:guide_wizard/models/language/language.dart';
import 'package:mobx/mobx.dart';

// Include generated file
part 'translation.g.dart';

// This is the class used by rest of your codebase
class Translation = _Translation with _$Translation;

abstract class _Translation with Store {
  @observable
  int id;

  @observable
  int text_id;

  @observable
  String translated_text;

  @observable
  int language_id;

  @observable
  Language language;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  _Translation({
    required this.id,
    required this.text_id,
    required this.translated_text,
    required this.language_id,
    required this.language,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

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

class TranslationFactory {
  Translation fromMap(Map<String, dynamic> json) {
    return Translation(
      id: json["id"],
      text_id: json["text_id"],
      translated_text: json["translated_text"],
      language_id: json["language_id"],
      language: LanguageFactory().fromMap(json["language"]),
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}
