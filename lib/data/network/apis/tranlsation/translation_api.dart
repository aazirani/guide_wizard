import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/technical_name/technical_name_with_translations_list.dart';

class TechnicalNameApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  TechnicalNameApi(this._dioClient, this._restClient);

  Future<TechnicalNameWithTranslationsList>
      getTechnicalNamesWithTranslations() async {
    try {
      final res = await _dioClient.get(Endpoints.getTechnicalNames);
      print("hereeeeeeeeeeeeeeee");
      print(res["rows"]);
      return TechnicalNameWithTranslationsList.fromJson(res["rows"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
