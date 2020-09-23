import 'package:route_app/core/models/response_model.dart';

/// Http client interface
abstract class Web {
  /// Send a GET request to the provided [url]
  Future<Response> get(String url);

  /// Send a POST request to the provided [url]
  Future<Response> post(String url, [dynamic body]);

  /// Send a DELETE request to the provided [url]
  Future<Response> delete(String url);

  /// Send a PUT request to the provided [url]
  Future<Response> put(String url, [dynamic body]);

  /// Send a PATCH request to the provided [url]
  Future<Response> patch(String url, [dynamic body]);
}