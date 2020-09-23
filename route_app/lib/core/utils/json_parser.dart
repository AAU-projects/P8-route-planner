import 'dart:convert';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/extensions/int.dart';
import 'package:http/http.dart' as http;

/// Parses body to json if possible
dynamic parseBody(dynamic body) {
  return body is Map ? jsonEncode(body) : body;
}

/// Parses a http response to json
Future<Response> parseJson(Future<http.Response> res) {
  // Add timeout for request
  res = res.timeout(const Duration(seconds: 5));

  return res.then((http.Response value) {
    if (!value.statusCode.between(199, 300)) {
      throw '''[${value.statusCode}] ${jsonDecode(value.body)}''';
    }

    Map<String, dynamic> json;
    // Ensure all headers are in lowercase
    final Map<String, String> headers = value.headers.map(
        (String h, String v) => MapEntry<String, String>(h.toLowerCase(), v));

    // Only decode if content is json
    if (headers.containsKey('content-type') &&
        headers['content-type'].toLowerCase().contains('application/json')) {
      if (!(jsonDecode(value.body) is Map)) {
        json = <String, dynamic>{'result': jsonDecode(value.body)};
      } else {
        json = jsonDecode(value.body);
      }
    }

    return Response(value, json);
  });
}
