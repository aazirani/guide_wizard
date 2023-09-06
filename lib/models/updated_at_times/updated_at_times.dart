import 'package:mobx/mobx.dart';

// Include generated file
part 'updated_at_times.g.dart';

// This is the class used by rest of your codebase
class UpdatedAtTimes = _UpdatedAtTimes with _$UpdatedAtTimes;

abstract class _UpdatedAtTimes with Store {
  @observable
  String last_updated_at_content;

  @observable
  String last_updated_at_technical_names;

  @observable
  String last_apps_request_time;

  static String LAST_UPDATED_AT_CONTENT = "last_updated_at_content";
  static String LAST_UPDATED_AT_TECHNICAL_NAMES =
      "last_updated_at_technical_names";
  static String LAST_APPS_REQUEST_TIME = "last_apps_request_time";

  _UpdatedAtTimes(
      {required this.last_updated_at_content,
      required this.last_updated_at_technical_names,
      required this.last_apps_request_time});

  Map<String, dynamic> toMap() {
    return {
      LAST_UPDATED_AT_CONTENT: last_updated_at_content,
      LAST_UPDATED_AT_TECHNICAL_NAMES: last_updated_at_technical_names,
      LAST_APPS_REQUEST_TIME: last_apps_request_time
    };
  }
}

class UpdatedAtTimesFactory {
  static String LAST_UPDATED_AT_CONTENT = "last_updated_at_content";
  static String LAST_UPDATED_AT_TECHNICAL_NAMES =
      "last_updated_at_technical_names";
  static String LAST_APPS_REQUEST_TIME = "last_apps_request_time";

  UpdatedAtTimes fromMap(Map<String, dynamic> json) {
    return UpdatedAtTimes(
        last_updated_at_content: json[LAST_UPDATED_AT_CONTENT],
        last_updated_at_technical_names: json[LAST_UPDATED_AT_TECHNICAL_NAMES],
        last_apps_request_time: json[LAST_APPS_REQUEST_TIME] != null
            ? json[LAST_APPS_REQUEST_TIME]
            : DateTime(1).toString());
  }

  UpdatedAtTimes fromJson(List<dynamic> json) {
    List<UpdatedAtTimes> updatedAtTimes;
    updatedAtTimes = json
        .map((updatedAt) => UpdatedAtTimesFactory().fromMap(updatedAt))
        .toList();
    updatedAtTimes.first.last_apps_request_time = DateTime.now().toString();
    return updatedAtTimes.first;
  }
}
