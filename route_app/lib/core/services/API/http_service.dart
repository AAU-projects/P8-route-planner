import 'package:flutter/material.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/core/utils/json_parser.dart';
import 'package:route_app/locator.dart';
import 'package:http/http.dart' as http;

/// Http service, send HTTP request
class HttpService implements Http {
  /// Default constructor
  HttpService({
    @required this.baseUrl,
    String tokenTable,
  }) : _tokenTable = tokenTable;

  final DatabaseService _db = locator.get<DatabaseService>();

  /// The base API url
  /// Example: if set to `http://google.com`, then a get request with url
  /// `/search` will resolve to `http://google.com/search`
  final String baseUrl;

  final String _tokenTable;

  Future<Map<String, String>> get _headers async {
    final Map<String, String> headers = <String, String>{
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final String _token = await token;

    if (_token != null) {
      headers['Authorization'] = 'Bearer ' + _token;
    }

    return headers;
  }

  @override
  Future<String> get token async {
    final List<Map<String, dynamic>> result =
        await _db.query(_tokenTable, limit: 1);

    if (result.isNotEmpty) {
      if (result.first.containsKey('JWT')) {
        if (DateTime.now().isBefore(DateTime.parse(result.first['expire']))) {
          return result.first['JWT'];
        }
      }
    }
    return null;
  }

  @override
  Future<bool> setToken(String token, String expire) async {
    // Delete all old tokens
    await _db.delete(_tokenTable, where: '1');

    // Row to insert
    final Map<String, dynamic> row = <String, String>{
      'JWT': token,
      'expire': expire
    };

    // Store new token
    return _db.insert(_tokenTable, row).then((int value) {
      return value > 0;
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
  Future<Response> get(String url) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(http.get(baseUrl + url, headers: headers));
    });
  }

  @override
  Future<Response> put(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return parseJson(
          http.post(baseUrl + url, headers: headers, body: parseBody(body)));
    });
  }

  @override
  Future<Response> delete(String url) {
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
}
