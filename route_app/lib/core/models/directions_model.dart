import 'location_model.dart';

/// Directions class
class Directions {
  /// Class Constructor
  Directions ({this.polyline, this.status, this.startLocation, 
    this.endLocation, this.distance, this.duration});

  /// The Google maps polyline
  String polyline;

  /// The status of the response
  String status;

  /// The start location
  Location startLocation;

  /// The end location
  Location endLocation;

  /// The distance as meters
  int distance;

  /// The duration in seconds
  int duration;
}