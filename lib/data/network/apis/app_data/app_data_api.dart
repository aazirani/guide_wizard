import 'dart:async';
import 'package:boilerplate/data/data_laod_handler.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/question/question_list.dart';
import 'package:boilerplate/models/step/step_list.dart';

class StepApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  StepApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<StepList> getSteps(String parameters) async {
    try {
      final res = await _dioClient.get(Endpoints.getAppData + parameters);
      // print("here it is:");
      // print(res["rows"]);
      return StepList.fromJson(res["rows"]);
    } catch (e) {
      print(e.toString());
      DataLoadHandler().showServerErrorMessage();
      throw e;
    }
  }
}
