import 'package:http/http.dart' as http;

/// Http response class
class Response {
  /// Default constructor
  Response(this.response, this.json);

  /// The response from the http client
  final http.Response response;

  /// The parsed json response
  final Map<String, dynamic> json;
}

/// Http client interface
abstract class Http {
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