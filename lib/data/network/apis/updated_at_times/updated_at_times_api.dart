import 'dart:async';
import 'dart:convert';

import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/data/network/dio_client.dart';
import 'package:guide_wizard/data/network/rest_client.dart';
import 'package:guide_wizard/models/updated_at_times/updated_at_times.dart';

class UpdatedAtTimesApi{
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  UpdatedAtTimesApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<UpdatedAtTimes> getUpdatedAtTimes(String parameters) async {
    try {
      final res = json.decode(await _dioClient.get(Endpoints.getUpdatedAtTimes + parameters));
      return UpdatedAtTimesFactory().fromJson([res]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
