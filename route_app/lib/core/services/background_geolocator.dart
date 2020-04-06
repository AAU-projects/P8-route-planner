import 'dart:convert';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geolocator/geolocator.dart';
import 'package:route_app/locator.dart';
import 'database.dart';

class BackgroundGeolocator {
  /// Default constructor
  BackgroundGeolocator() {
    startGeolocator();
  }

  final DatabaseService _db = locator.get<DatabaseService>();

  /// Starts the geolocator
  void startGeolocator() {
    /// Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final Position pos = locationToPosition(location);

      _db.insert('logs', <String, String>{'json': jsonEncode(pos.toJson())});
      batchUploadToDatabase();
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
  Position locationToPosition(bg.Location loc) {
    // Speed accuracy is not available in background service,
    // therefore is set to default 0.0.
    final Position pos = Position(
        longitude: loc.coords.longitude,
        latitude: loc.coords.latitude,
        timestamp: DateTime.parse(loc.timestamp),
        mocked: false,
        accuracy: loc.coords.accuracy,
        altitude: loc.coords.altitude,
        heading: loc.coords.heading,
        speed: loc.coords.speed,
        speedAccuracy: 0.0);

    return pos;
  }

  List<Position> logsToPostitions(List<Map<String, dynamic>> logs) {
    List<Position> listOfPositions = <Position>[];

    for (Map<String, dynamic> log in logs) {
      final dynamic json = jsonDecode(log['json']);

      listOfPositions.add(Position(
        longitude: json['longitude'],
        latitude: json['latitude'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
        mocked: false,
        accuracy: json['accuracy'],
        altitude: json['altitude'],
        heading: json['heading'],
        speed: json['speed'],
        speedAccuracy: 0.0)
      );
    }

    return listOfPositions;
  }

  /// Sends the location logs to the database
  void batchUploadToDatabase() async {
    String dbTable = 'logs';
    // Gets the count of location logs from the internal database
    // and checks if they exceeded 100.
    final int count = await _db.getCount(dbTable);
    if (count >= 2) {
      final List<Map<String, dynamic>> logs = await _db.query(dbTable);

      // Make Position objects from Json
      List<Position> positions = logsToPostitions(logs);

      for (Position position in positions) {
        print('\n' + position.toString() + '\n');
      }
      // Send to the external database as list of Positions
    }
  }
}
