import 'package:route_app/core/models/logging_position.dart';

/// Logging API endpoints
abstract class LoggingAPI {

  /// Posts a list of positions to the logging endpoint
  Future<bool> postPositions(List<LogPosition> positions);
}