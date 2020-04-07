import 'dart:convert';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:route_app/core/models/logging_position.dart';
import 'package:route_app/core/services/API/logging_service.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/locator.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

/// Service for logging geolocation when the application
/// is running in the background
class BackgroundGeolocator {
  /// Default constructor
  BackgroundGeolocator() {
    _startGeolocator();
  }

  final DatabaseService _db = locator.get<DatabaseService>();
  final LoggingService _loggingService = locator.get<LoggingAPI>();

  /// Starts the geolocator
  void _startGeolocator() {
    /// Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final LogPosition pos = _locationToPosition(location);

      _db.insert('logs', <String, String>{'json': jsonEncode(pos.toJson())});
      _batchUploadToDatabase();
    });

    /// Configure the plugin
    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: false,
            logLevel: bg.Config.LOG_LEVEL_OFF))
        .then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  /// Converts a location to a position
  LogPosition _locationToPosition(bg.Location loc) {
    // Speed accuracy is not available in background service,
    // therefore is set to default 0.0.

    final LogPosition pos = LogPosition(
        longitude: loc.coords.longitude,
        latitude: loc.coords.latitude,
        timestamp: DateTime.parse(loc.timestamp).toIso8601String(),
        accuracy: loc.coords.accuracy,
        altitude: loc.coords.altitude,
        heading: loc.coords.heading,
        speed: loc.coords.speed,
        speedAccuracy: 0.0);
    return pos;
  }

  List<LogPosition> _logsToPostitions(List<Map<String, dynamic>> logs) {
    final List<LogPosition> listOfPositions = <LogPosition>[];

    for (Map<String, dynamic> log in logs) {
      final dynamic json = jsonDecode(log['json']);

      listOfPositions.add(LogPosition(
          longitude: json['longitude'],
          latitude: json['latitude'],
          timestamp: json['timestamp'],
          accuracy: json['accuracy'],
          altitude: json['altitude'],
          heading: json['heading'],
          speed: json['speed'],
          speedAccuracy: 0.0));
    }

    return listOfPositions;
  }

  /// Sends the location logs to the database
  Future<void> _batchUploadToDatabase() async {
    const String dbTable = 'logs';
    // Gets the count of location logs from the internal database
    // and checks if they exceeded 100.
    final int count = await _db.getCount(dbTable);
    if (count >= 100) {
      final Batch batch = await _db.batch();
      batch.query(dbTable);
      batch.delete(dbTable);
      final dynamic results = await batch.commit();
      // Since the batch results comes with a count,
      // we need to take the first element
      final List<Map<String, dynamic>> logs = results[0];

      if (logs.isNotEmpty) {
        // Make Position objects from Json
        final List<LogPosition> positions = _logsToPostitions(logs);

        // Send to the external database as list of Positions
        _loggingService.postPositions(positions);
      }
    }
  }
}
