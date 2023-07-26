class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://dev-wg.collegiality.de/api/app";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getAppData = baseUrl + "/content/answerIds/";

  static const String getTechnicalNames = baseUrl + "/translations?answerIds=";

  static const String getUpdatedAtTimes = baseUrl + "/lastUpdates?answerIds=";

  static const String tasksImageBaseUrl = "http://dev-wg.collegiality.de/tasks/image/";
  static const String answersImageBaseUrl = "http://dev-wg.collegiality.de/answers/image/";
  static const String stepsImageBaseUrl = "http://dev-wg.collegiality.de/steps/image/";
}
