import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/post/post_list.dart';
import 'package:boilerplate/models/translation/translation_list.dart';

class TranslationApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  TranslationApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<TranslationList> getTranslations() async {
    try {
      final res = await _dioClient.get(Endpoints.getTranslations);
      return TranslationList.fromJson(res["rows"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
