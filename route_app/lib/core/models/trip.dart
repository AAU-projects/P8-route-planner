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

  /// The latitude of this position in degrees normalized to the interval 
  /// -90.0 to +90.0 (both inclusive).
  final List<Position> tripPosition;

  /// The longitude of the position in degrees normalized to the interval 
  /// -180 (exclusive) to +180 (inclusive).
  final int tripDuration;

  /// The time at which this position was determined.
  /// Converted to a ISO string.
  final Transport transport;

  final String startDestination;
  final String endDestination;
}
