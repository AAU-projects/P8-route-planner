import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:route_app/core/models/logging_position.dart';
import 'package:route_app/core/services/API/logging_service.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/locator.dart';
import 'database.dart';

/// Service for logging geolocation when the application
/// is running in the background
class BackgroundGeolocator {
  /// Default constructor
  BackgroundGeolocator() {
    _startGeolocator();
    _uploadTime = _generateUploadTime();
    _timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => _checkUploadTime());
  }

  DateTime _uploadTime;
  final DatabaseService _db = locator.get<DatabaseService>();
  final LoggingService _loggingService = locator.get<LoggingAPI>();
  Timer _timer;

  /// For forcing a upload of the logs in development.
  void uploadLogs() {
    _uploadTime = DateTime.now().toUtc().add(const Duration(minutes: 1));
  }

  /// For clearing the timer when the screen is disposed.
  void clearTimer() {
    _timer.cancel();
  }

  DateTime _generateUploadTime() {
    final DateTime current = DateTime.now().toUtc();
    final Random rand = Random();
    final DateTime newTime = current
        .add(Duration(hours: rand.nextInt(22) + 1, minutes: rand.nextInt(59)));
    return newTime;
  }

  void _checkUploadTime() {
    final DateTime current = DateTime.now().toUtc();
    if (current.hour == _uploadTime.hour &&
        current.minute == _uploadTime.minute) {
      _batchUploadToDatabase();
    }
  }

  /// Starts the geolocator
  void _startGeolocator() {
    /// Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final LogPosition pos = _locationToPosition(location);

      // Insert the logged position in the application database
      _db.insert('logs', <String, String>{'json': jsonEncode(pos.toJson())});
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

  /// Takes a result of logs from the application database
  /// and converts it to a list of LogPosition's
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

  /// Sends the location logs to the API
  Future<void> _batchUploadToDatabase() async {
    final List<LogPosition> lastLog = _logsToPostitions(await _db.getLastLog());
    final DateTime lastLogTime = DateTime.parse(lastLog[0].timestamp);
    final DateTime currentTime = DateTime.now().toUtc();

    // Do not upload if trip is ongoing
    if (currentTime.difference(lastLogTime) < const Duration(minutes: 5)) {
      _uploadTime = _uploadTime.add(const Duration(minutes: 5));
      return;
    }

    const String dbTable = 'logs';
    final dynamic results = await _db.query(dbTable);
    final List<Map<String, dynamic>> logs = results;

    if (logs.isNotEmpty) {
      // Make Position objects from Json
      final List<LogPosition> positions = _logsToPostitions(logs);

      // Send to the external database as list of Positions
      if (await _loggingService.postPositions(positions)) {
        await _db.delete(dbTable);
      } else {
        _uploadTime = _uploadTime.add(const Duration(minutes: 5));
      }
    }
  }
}
