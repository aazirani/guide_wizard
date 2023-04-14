import 'dart:async';

import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/dio_client.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/models/updated_at_times/updated_at_times.dart';

class UpdatedAtTimesApi{
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  UpdatedAtTimesApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<UpdatedAtTimes> getUpdatedAtTimes() async {
    try {
      final res = await _dioClient.get(Endpoints.getUpdatedAtTimes);
      return UpdatedAtTimes.fromMap(res["rows"]);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
