import 'dart:async';

import 'package:guide_wizard/data/data_load_handler.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/data/network/dio_client.dart';
import 'package:guide_wizard/data/network/rest_client.dart';
import 'package:guide_wizard/models/technical_name/technical_name_with_translations_list.dart';

class TechnicalNameApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  TechnicalNameApi(this._dioClient, this._restClient);

  Future<TechnicalNameWithTranslationsList> getTechnicalNamesWithTranslations(String parameters) async {
    try {
      final res = await _dioClient.get(Endpoints.getTechnicalNames + parameters);
      return TechnicalNameWithTranslationsList.fromJson(res["rows"]);
    } catch (e) {
      print(e.toString());
      DataLoadHandler().showServerErrorMessage();
      throw e;
    }
  }
}
