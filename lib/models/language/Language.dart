class Language {
  int id;
  String language_code;
  String language_name;
  bool is_active;
  bool is_main_language;
  int creator_id;
  String created_at;
  String updated_at;

  Language({
    required this.id,
    required this.language_code,
    required this.language_name,
    required this.is_active,
    required this.is_main_language,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Language.fromMap(Map<String, dynamic> json) {
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
