import 'dart:convert';
import 'package:route_app/core/extensions/int.dart';
import 'package:flutter/material.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';
import 'package:http/http.dart' as http;

/// Http service, send HTTP request 
class HttpService implements Http {
  /// Default constructor
  HttpService({
    @required this.baseUrl,
    String tokenTable,
    Duration timeout = const Duration(seconds: 5)
  }): _timeout = timeout, _tokenTable = tokenTable;

  final DatabaseService _db = locator.get<DatabaseService>();

  /// The base API url
  /// Example: if set to `http://google.com`, then a get request with url
  /// `/search` will resolve to `http://google.com/search`
  final String baseUrl;

  final Duration _timeout;
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
      await _db.query(_tokenTable, limit:1);

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
      return _parseJson(
          http.post(
              baseUrl + url,
              headers: headers,
              body: _parseBody(body)));
    });
  }

  @override
  Future<Response> get(String url) {
    return _headers.then((Map<String, String> headers) {
      return _parseJson(
        http.get(
          baseUrl + url,
          headers: headers
        )
      );
    });
  }

  @override
  Future<Response> put(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return _parseJson(
          http.post(
              baseUrl + url,
              headers: headers,
              body: _parseBody(body)));
    });
  }

  @override
  Future<Response> delete(String url) {
    return _headers.then((Map<String, String> headers) {
      return _parseJson(
          http.get(
              baseUrl + url,
              headers: headers
              )
          );
    });
  }

  @override
  Future<Response> patch(String url, [dynamic body]) {
    return _headers.then((Map<String, String> headers) {
      return _parseJson(
          http.post(
              baseUrl + url,
              headers: headers,
              body: _parseBody(body)));
    });
  }

  dynamic _parseBody(dynamic body) {
    return body is Map ? jsonEncode(body) : body;
  }

  Future<Response> _parseJson(Future<http.Response> res) {
    // Add timeout for request
    res = res.timeout(_timeout);

    return res.then((http.Response value) {

      if (!value.statusCode.between(199, 300)) {
        throw '''[${value.statusCode}] ${jsonDecode(value.body)['title']}''';
      }

      Map<String, dynamic> json;
      // Ensure all headers are in lowercase
      final Map<String, String> headers = value.headers.map(
       (String h, String v) => MapEntry<String, String>(h.toLowerCase(), v));

      // Only decode if content is json
      if (headers.containsKey('content-type') 
       && headers['content-type'].toLowerCase().contains('application/json')) {
        if (!(jsonDecode(value.body) is Map)) {
          json = <String, dynamic>{
            'result': jsonDecode(value.body)
          };
        } else {
          json = jsonDecode(value.body);
        }
      }

      return Response(value, json);
    });
  }


}
