import 'package:mobx/mobx.dart';

// Include generated file
part 'language.g.dart';

// This is the class used by rest of your codebase
class Language = _Language with _$Language;

abstract class _Language with Store {
  @observable
  int id;

  @observable
  String language_code;

  @observable
  String language_name;

  @observable
  bool is_active;

  @observable
  bool is_main_language;

  @observable
  int creator_id;

  @observable
  String created_at;

  @observable
  String updated_at;

  _Language({
    required this.id,
    required this.language_code,
    required this.language_name,
    required this.is_active,
    required this.is_main_language,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "language_code": language_code,
        "language_name": language_name,
        "is_active": is_active,
        "is_main_language": is_main_language ? 1 : 0,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}

class LanguageFactory {
  Language fromMap(Map<String, dynamic> json) {
    return Language(
      id: json["id"],
      language_code: json["language_code"],
      language_name: json["language_name"],
      is_active: json["is_active"] == 1 ? true : false,
      is_main_language: json["is_main_language"] == 1 ? true : false,
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }
}
