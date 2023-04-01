class Language {
  int id;
  String language_code;
  int is_active;
  int creator_id;
  String created_at;
  String updated_at;

  Language({
    required this.id,
    required this.language_code,
    required this.is_active,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Language.fromMap(Map<String, dynamic> json) {
    return Language(
      id: json["id"],
      language_code: json["language_code"],
      is_active: json["is_active"],
      creator_id: json["creator_id"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "language_code": language_code,
        "is_active": is_active,
        "creator_id": creator_id,
        "created_at": created_at,
        "updated_at": updated_at,
      };
}
