/// Position model for sending logs to the backend
class LogPosition {
  /// Default Constructor
  LogPosition({
    this.longitude,
    this.latitude,
    this.timestamp,
    this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    this.speedAccuracy,
  });

  /// The latitude of this position in degrees normalized to the interval 
  /// -90.0 to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval 
  /// -180 (exclusive) to +180 (inclusive).
  final double longitude;

  /// The time at which this position was determined.
  /// Converted to a ISO string.
  final String timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. 
  /// In these cases the returned value is 0.0.
  final double altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. 
  /// In these cases the value is 0.0.
  final double accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. 
  /// In these cases the value is 0.0.
  final double heading;

  /// The speed at which the devices is traveling 
  /// in meters per second over ground.
  ///
  /// The speed is not available on all devices. 
  /// In these cases the value is 0.0.
  final double speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. 
  /// In these cases the value is 0.0.
  final double speedAccuracy;

  /// Converts the [Position] instance into a 
  /// [Map] instance that can be serialized to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'longitude': longitude,
    'latitude': latitude,
    'timestamp': timestamp,
    'accuracy': accuracy,
    'altitude': altitude,
    'heading': heading,
    'speed': speed,
    'speedAccuracy': speedAccuracy,
  };
}
