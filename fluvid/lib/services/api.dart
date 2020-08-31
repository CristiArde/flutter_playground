import 'package:flutter/cupertino.dart';
import 'package:fluvid/services/api_endpoints.dart';
import 'package:fluvid/services/api_keys.dart';
import 'package:enum_to_string/enum_to_string.dart';

class API {
  API({@required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.covidSandboxKey);

  static final String host = 'ncov2019-admin.firebaseapp.com';

  //creates and returns a URL
  Uri tokenUri() => Uri(
    scheme: 'https',
    host: host,
    path: 'token'
  );

  Uri queryUri(Query query) => Uri(
    scheme: 'https',
    host: host,
    path: EnumToString.parse(query)
  );
}