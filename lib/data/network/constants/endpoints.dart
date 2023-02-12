class Endpoints {
  Endpoints._();

  // base url
  // static const String baseUrl = "http://jsonplaceholder.typicode.com";
  static const String baseUrl = "http://collegiality.de";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";

  static const String getAppData = baseUrl + "/2nd_sample_hierarchy";
}
  static const String getTranslations = baseUrl + "/sample_technical_names.json";
}

