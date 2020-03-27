import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/models/location_model.dart';
import 'package:route_app/core/services/API/http_service.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';

import 'interfaces/http.dart';

/// Google maps service
class GoogleMapsService implements GoogleMapsAPI {
  /// Class constructor
  GoogleMapsService({String apiKey}) {
    if (apiKey == null) {
      _apiKey = const String.fromEnvironment('GOOGLE_API_KEY');
    } else {
      _apiKey = apiKey;
    }
  }

  @override
  Future<Directions> getDirections(
      {String origin,
      String destination,
      String travelMode = 'driving'}) async {
    final String params = 'origin=' +
        origin +
        '&destination=' +
        destination.replaceAll(' ', '+') +
        '&key=' +
        _apiKey;

    return _httpclient.get(params).then((Response resp) {
      final String poly = _getPolyline(resp);
      final String status = _getStatus(resp);
      final Location startLoc = _getStartLocation(resp);
      final Location endLoc = _getEndLocation(resp);
      final int dist = _getDistance(resp);
      final int dur = _getDuration(resp);
      return Directions(
          polyline: poly,
          status: status,
          startLocation: startLoc,
          endLocation: endLoc,
          distance: dist,
          duration: dur);
    });
  }

  final HttpService _httpclient = HttpService(
      baseUrl: 'https://maps.googleapis.com/maps/api/directions/json?');
  String _apiKey;

  /// Gets the polyline from a response object
  String _getPolyline(Response response) {
    return response.json['routes'].overview_polyline.points;
  }

  /// Gets the status of the response
  String _getStatus(Response response) {
    return response.json['status'];
  }

  /// Gets the start location
  Location _getStartLocation(Response response) {
    return Location(
        response.json['routes'].legs.start_address,
        response.json['routes'].legs.start_location.lat,
        response.json['routes'].legs.start_location.lng);
  }

  /// Gets the end location
  Location _getEndLocation(Response response) {
    return Location(
        response.json['routes'].legs.end_address,
        response.json['routes'].legs.end_address.lat,
        response.json['routes'].legs.end_address.lng);
  }

  /// Gets the distance as meters
  int _getDistance(Response response) {
    return response.json['routes'].legs.distance.value;
  }

  /// Gets the duration in seconds
  int _getDuration(Response response) {
    return response.json['routes'].legs.duration.value;
  }
}
