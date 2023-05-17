class UpdatedAtTimes {
  //Server Values
  String last_updated_at_content;
  String last_updated_at_technical_names;

  UpdatedAtTimes({
    required this.last_updated_at_content,
    required this.last_updated_at_technical_names,
  });

  factory UpdatedAtTimes.fromMap(Map<String, dynamic> json) {
    return UpdatedAtTimes(
      last_updated_at_content: json["last_updated_at_content"],
      last_updated_at_technical_names: json["last_updated_at_technical_names"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "last_updated_at_content": last_updated_at_content,
      "last_updated_at_technical_names": last_updated_at_technical_names,
    };
  }

  factory UpdatedAtTimes.fromJson(List<dynamic> json) {
    List<UpdatedAtTimes> updatedAtTimes;
    updatedAtTimes = json.map((updatedAt) => UpdatedAtTimes.fromMap(updatedAt)).toList();

    return updatedAtTimes.first;
  }

}
