class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://dev-wg.collegiality.de/api/app";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getAppData = baseUrl + "/content";

  static const String getTechnicalNames = baseUrl + "/translations";

  static const String getUpdatedAtTimes = baseUrl + "/lastUpdates";

  static const String imageBaseUrl = "http://dev-wg.collegiality.de/tasks/image/";
}
