import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import 'api_endpoints.dart';

class APIService {
  final API api;

  APIService(this.api);


  Future<String> getAccessToken() async {
    final response = await http.post(api.tokenUri().toString(),
        headers: {'Authorization': 'Basic ${api.apiKey}'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    printResponse(api.tokenUri(), response.statusCode, response.reasonPhrase);
    throw response;
  }

  Future<int> getQueryData({@required String accessToken, @required Query query}) async {
    final url = api.queryUri(query);
    final response = await http.get(url.toString(),
                                    headers: {'Authorization' : 'Bearer $accessToken'});

    if(response.statusCode == 200){
      //contains a list with map inside
        final List<dynamic> responseJson = json.decode(response.body);
        if(responseJson.isNotEmpty){
          final Map<String, dynamic> dataMap = responseJson[0];
          int result = dataMap[EnumToString.parse(query)];
          if(result != null){
            return result;
          }
        }
    }
    printResponse(url, response.statusCode, response.reasonPhrase);
    throw response;
  }

  static void printResponse(Uri url, int statusCode, String reason){
    print('Request $url failed \n Response: $statusCode with $reason');
  }
}
