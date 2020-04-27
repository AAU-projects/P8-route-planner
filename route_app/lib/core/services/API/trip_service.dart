import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';

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
      return res.json['result'];
    });
  }
}