import 'package:route_app/core/models/trip.dart';

/// Trips API endpoint
abstract class TripsAPI {
  /// Gets a list of trips
  Future<List<Trip>> getTrips();
}