class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://qa-wg.collegiality.de";

  // app api
  static const String appApiUrl = baseUrl + "/api/app";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getAppData = appApiUrl + "/content/answerIds/";

  static const String getTechnicalNames =
      appApiUrl + "/translations?answerIds=";

  static const String getUpdatedAtTimes = appApiUrl + "/lastUpdates?answerIds=";

  static const String tasksImageBaseUrl = baseUrl + "/tasks/image/";
  static const String answersImageBaseUrl = baseUrl + "/answers/image/";
  static const String stepsImageBaseUrl = baseUrl + "/steps/image/";
}
