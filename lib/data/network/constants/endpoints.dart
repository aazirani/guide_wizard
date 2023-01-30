class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://collegiality.de";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";
  static const String getTranslations = baseUrl + "/sample_technical_names.json";
}