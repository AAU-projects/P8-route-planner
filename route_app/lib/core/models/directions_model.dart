import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'location_model.dart';

/// Directions class
class Directions {
  /// Class Constructor
  Directions(
      {this.polyline,
      this.status,
      this.startLocation,
      this.endLocation,
      this.distance,
      this.duration,
      this.polylinePoints});

  /// The Google maps polyline as a string
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

  /// The list of points to draw a polyline
  List<LatLng> polylinePoints;

  /// The widget icon for the directions
  IconData icon;

  /// The emission for this trip.
  double emission;

  /// The price for the trip.
  double price;
}
