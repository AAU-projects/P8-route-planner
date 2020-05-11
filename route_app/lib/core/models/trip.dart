import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/enums/Transport_Types.dart';
import 'package:route_app/core/models/model.dart';
import 'package:route_app/core/extensions/map.dart';


/// Trip model
class Trip implements Model{
  /// Default Constructor
  Trip({
    this.id,
    this.tripPosition,
    this.tripDuration,
    this.transport
  });

  /// Constructor to instantiate from json
  Trip.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException('Cant initialize on empty json');
    }
    id = json['Id'];
    // get trip positions
    date = DateTime.tryParse(json.get('TripDate', DateTime.now()));
    tripDuration = json['TripDuration'];
    transport = Transport.values[json['Transport']];
  }

  /// The trips id
  String id;

  /// The trip positions for a trip
  List<Position> tripPosition;

  /// The trip duration for a trip
  int tripDuration;

  /// The means of transport for a trip
  Transport transport;

  /// The trip date
  DateTime date;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      // trips
      'TripDuration': tripDuration,
      'Transport': transport.index,
      'TripDate': date
    };
  }
}