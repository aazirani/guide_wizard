class UpdatedAtTimes {
  //Server Values
  String last_updated_at_content;
  String last_updated_at_technical_names;

  static String LAST_UPDATED_AT_CONTENT = "last_updated_at_content";
  static String LAST_UPDATED_AT_TECHNICAL_NAMES = "last_updated_at_technical_names";

  UpdatedAtTimes({
    required this.last_updated_at_content,
    required this.last_updated_at_technical_names,
  });

  factory UpdatedAtTimes.fromMap(Map<String, dynamic> json) {
    return UpdatedAtTimes(
      last_updated_at_content: json[LAST_UPDATED_AT_CONTENT],
      last_updated_at_technical_names: json[LAST_UPDATED_AT_TECHNICAL_NAMES],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      LAST_UPDATED_AT_CONTENT: last_updated_at_content,
      LAST_UPDATED_AT_TECHNICAL_NAMES: last_updated_at_technical_names,
    };
  }

  factory UpdatedAtTimes.fromJson(List<dynamic> json) {
    List<UpdatedAtTimes> updatedAtTimes;
    updatedAtTimes = json.map((updatedAt) => UpdatedAtTimes.fromMap(updatedAt)).toList();

    return updatedAtTimes.first;
  }

}
