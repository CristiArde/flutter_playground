import 'package:flutter/cupertino.dart';
import 'package:fluvid/services/api_endpoints.dart';
import 'package:fluvid/services/api_service.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  String _token;

  DataRepository({@required this.apiService});

  Future<int> getQueryData(Query query) async {
    //try to get a access code .. if the code is 401 (expired) then request a new one
    // else its a different error that we display in the UI via rethrow
    try {
      if (_token == null) {
        _token = await apiService.getAccessToken();
      }
      return await apiService.getQueryData(
          accessToken: _token, query: query);
    } on Response catch (response){
        if(response.statusCode == 401){
          _token = await apiService.getAccessToken();
          return await apiService.getQueryData(
              accessToken: _token, query: query);
        }
      rethrow;
    }
  }
}
