import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:route_app/core/services/interfaces/http.dart';

enum Method { get, post, put, delete, patch }

class Call {
  Call(this.method, this.url, [this.body]);

  final Method method;
  final dynamic body;
  final String url;

  dynamic _response;
  String _errorMessage;
  Future<dynamic> get response async {
    if (_response != null) {
      return _response;
    } else if (_errorMessage != null) {
      return Exception(_errorMessage);
    }
    return Future<dynamic>.delayed(
        const Duration(milliseconds: 10), () => response); // ignore: recursive_getters

  }

  set response(dynamic value) => _response = value;
  set error(String value) => _errorMessage = value;
}

class Flusher {
  Flusher(this._call);
  final Call _call;

  /// Flush a body to our listener
  ///
  /// [response] The response to flush
  void flush(dynamic response) {
    _call.response = response;
  }

  /// Send an exception to our listener
  ///
  /// [exception] The exception to send
  void throwError(dynamic exception) {
    _call._errorMessage = exception;
  }
}

class HttpMock implements Http {
  final List<Call> _calls = <Call>[];
  String _token;

  /// Expect a request with the given method and url.
  ///
  /// [method] One of delete, get, patch, post, or put.
  /// [url] The url that is expected
  Flusher expectOne({Method method, @required String url, dynamic body}) {
    final int index = _calls.indexWhere((Call call) =>
    call.url == url &&
        (method == null || method == call.method) &&
        (body == null || body == call.body));

    if (index == -1) {
      throw Exception('Expected [$method] $url, found none');
    }

    final Call call = _calls[index];
    _calls.removeAt(index);
    return Flusher(call);
  }

  /// Ensure that no request with the given method and url is send
  ///
  /// [method] One of delete, get, patch, post, or put.
  /// [url] The url that not expected
  void expectNone({Method method, @required String url}) {
    for (Call call in _calls) {
      if (call.url == url && (method == null || method == call.method)) {
        throw Exception('Found [$method] $url, expected none');
      }
    }
  }

  @override
  Future<bool> setToken(String token, String expire) {
    _token = token;
    return Future<bool>.value(true);
  }

  @override
  Future<String> get token => Future<String>.value(_token);

  @override
  Future<Response> delete(String url) {
    return _makeResponse(Method.delete, url);
  }

  @override
  Future<Response> get(String url) {
    return _makeResponse(Method.get, url);
  }

  @override
  Future<Response> patch(String url, [dynamic body]) {
    return _makeResponse(Method.patch, url, body);
  }

  @override
  Future<Response> post(String url, [dynamic body]) {
    return _makeResponse(Method.post, url, body);
  }

  @override
  Future<Response> put(String url, [dynamic body]) {
    return _makeResponse(Method.put, url, body);
  }

  Future<Response> _makeResponse(Method method, String url, [dynamic body]) {
    final Call call = Call(method, url, body);
    _calls.add(call);

    return call.response.then((dynamic value) {
      if (value is Exception) {
        return Future<Response>.error(value);
      }
      if (value is String) {
        value = <String, dynamic>{
          'result': jsonDecode(value)
        };
      }
      return Response(null, value);
    });
  }
}
