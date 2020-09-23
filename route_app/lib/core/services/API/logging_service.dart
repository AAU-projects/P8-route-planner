import 'dart:convert';

import 'package:route_app/core/models/logging_position.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';

/// Logging endpoints
class LoggingService implements LoggingAPI {
  /// Default constructor
  LoggingService({
    String endpoint = 'logging/'
  }): _endpoint = endpoint;

  final String _endpoint;
  final Http _http = locator.get<Http>();

  @override
  Future<bool> postPositions(List<LogPosition> positions) {
    return _http.post(_endpoint, jsonEncode(positions)).then((Response res) {
      return res.json['result'];
    });
  }
}