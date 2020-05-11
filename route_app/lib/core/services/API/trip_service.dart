import 'package:intl/intl.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/core/extensions/map.dart';

/// Trip endpoints
class TripService implements TripsAPI {
  /// Default constructor
  TripService({
    String endpoint = 'trip/'
  }): _endpoint = endpoint;

  final String _endpoint;
  final Http _http = locator.get<Http>();

  @override
  Future<List<Trip>> getTrips() {
    return _http.get(_endpoint).then((Response res) {
      final List<Trip> result = <Trip>[];

      if (res.json != null) {
        res.json.get('result', <Trip>[]).forEach((dynamic day) {
          day['TripList'].forEach((dynamic trip) {
            result.add(Trip.fromJson(trip));
          });
        });
      }

      return result;
    });
  }

  @override
  Future<bool> updateTrip(Trip trip) {
    return _http.patch(_endpoint, <String, dynamic>{
      'date': DateFormat('dd-MM-yyyy').format(trip.date),
      'tripId': trip.id,
      'transport': trip.transport.index
    }).then((_) {
      return true;
    });
  }

}