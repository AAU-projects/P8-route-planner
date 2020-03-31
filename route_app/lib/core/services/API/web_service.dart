import 'package:flutter/cupertino.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/services/interfaces/web.dart';
import 'package:route_app/core/utils/json_parser.dart';
import 'package:http/http.dart' as http;

/// Web service to send HTTP requests to any api
class WebService implements Web {
  /// Default constructor
  WebService({@required this.baseUrl});

  /// The base url of the API
  String baseUrl;

  Future<Map<String, String>> get _headers async {
    final Map<String, String> headers = <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return headers;
  }

  @override
  Future<Response> delete(String url) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(http.get(baseUrl + url, headers: headers));
    });
  }

  @override
  Future<Response> get(String url) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(http.get(baseUrl + url, headers: headers));
    });
  }

  @override
  Future<Response> patch(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(
          http.post(baseUrl + url, headers: headers, body: parseBody(body)));
    });
  }

  @override
  Future<Response> post(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(
          http.post(baseUrl + url, headers: headers, body: parseBody(body)));
    });
  }

  @override
  Future<Response> put(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(
          http.post(baseUrl + url, headers: headers, body: parseBody(body)));
    });
  }
}
