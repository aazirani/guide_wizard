class Translation {
  int id;
  int text_id;
  String translated_text;
  String language_code;
  int creator_id;
  String created_at;
  String updated_at;

  Translation({
    required this.id,
    required this.text_id,
    required this.translated_text,
    required this.language_code,
    required this.creator_id,
    required this.created_at,
    required this.updated_at,
  });

  factory Translation.fromMap(Map<String, dynamic> json) {
    return Translation(
      id: json["id"],
      text_id: json["text_id"],
      translated_text: json["translated_text"],
      language_code: json["language"]["language_code"],
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
      "language_code": language_code,
      "creator_id": creator_id,
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }
}