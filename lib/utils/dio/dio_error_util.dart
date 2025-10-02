import 'package:dio/dio.dart';

class DioErrorUtil {
  // general methods:------------------------------------------------------------
  static String handleError(DioException error) {
      return "There was an error in the request to the API server";;
  }
}