import 'dart:async';

import 'package:guide_wizard/data/data_laod_handler.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/data/network/dio_client.dart';
import 'package:guide_wizard/data/network/rest_client.dart';
import 'package:guide_wizard/models/step/step_list.dart';

class StepApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  StepApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<AppStepList> getSteps(String parameters) async {
    try {
      final res = await _dioClient.get(Endpoints.getAppData + parameters);
      return AppStepList.fromJson(res["rows"]);
    } catch (e) {
      print(e.toString());
      DataLoadHandler().showServerErrorMessage();
      throw e;
    }
  }
}
