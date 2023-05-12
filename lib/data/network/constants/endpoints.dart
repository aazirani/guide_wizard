class Endpoints {
  Endpoints._();

  // base url
  // static const String baseUrl = "https://collegiality.de";
  static const String baseUrl = "https://glamapp.ir/collegiality";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";

  static const String getAppData = baseUrl + "/2nd_sample_hierarchy.json";
  // static const String afterUpdateGetAppData = baseUrl + "/2nd_sample_hierarchy_after_update.json";
  // static const String getAppData = baseUrl + "/2nd_sample_hierarchy_after_update.json";

  static const String getTechnicalNames = baseUrl + "/sample_technical_names.json";
  // static const String afterUpdateGetTechnicalNames = baseUrl + "/sample_technical_names_after_update.json";
  // static const String getTechnicalNames = baseUrl + "/sample_technical_names_after_update.json";

  static const String getUpdatedAtTimes = baseUrl + "/updated_at_times.json";
  // static const String afterUpdateGetUpdatedAtTimes = baseUrl + "/updated_at_times_after_update.json";
  // static const String getUpdatedAtTimes = baseUrl + "/updated_at_times_after_update.json";
}
