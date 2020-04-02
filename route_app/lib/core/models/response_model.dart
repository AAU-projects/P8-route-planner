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