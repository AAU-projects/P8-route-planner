import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/enums/Transport_Types.dart';

/// Trip model
class Trip {
  /// Default Constructor
  Trip({
    this.tripPosition,
    this.tripDuration,
    this.transport,
    this.startDestination,
    this.endDestination
  });

  /// The trip positions for a trip
  final List<Position> tripPosition;

  /// The trip duration for a trip
  final int tripDuration;

  /// The means of transport for a trip
  final Transport transport;

  /// Start destiation of a trip
  final String startDestination;

  /// End destiation of a trip
  final String endDestination;
}
