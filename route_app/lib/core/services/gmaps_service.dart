import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/models/location_model.dart';
import 'package:route_app/core/models/response_model.dart';
import 'package:route_app/core/services/API/web_service.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/core/services/interfaces/web.dart';
import 'package:route_app/locator.dart';

/// Google maps service
class GoogleMapsService implements GoogleMapsAPI {
  /// Class constructor
  GoogleMapsService(this._apiKey, {WebService webService}){
    _webService = webService ?? locator.get<Web>(param1: 'https://maps.googleapis.com/maps/api/directions/json?');
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

    return _webService.get(params).then((Response resp) {
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

  WebService _webService;
  final String _apiKey;

  /// Gets the polyline from a response object
  String _getPolyline(Response response) {
    return response.json['routes'][0]['overview_polyline']['points'];
  }

  /// Gets the status of the response
  String _getStatus(Response response) {
    return response.json['status'];
  }

  /// Gets the start location
  Location _getStartLocation(Response response) {
    return Location(
        response.json['routes'][0]['legs'][0]['start_address'],
        response.json['routes'][0]['legs'][0]['start_location']['lat'],
        response.json['routes'][0]['legs'][0]['start_location']['lng']);
  }

  /// Gets the end location
  Location _getEndLocation(Response response) {
    return Location(
        response.json['routes'][0]['legs'][0]['end_address'],
        response.json['routes'][0]['legs'][0]['end_location']['lat'],
        response.json['routes'][0]['legs'][0]['end_location']['lng']);
  }

  /// Gets the distance as meters
  int _getDistance(Response response) {
    return response.json['routes'][0]['legs'][0]['distance']['value'];
  }

  /// Gets the duration in seconds
  int _getDuration(Response response) {
    return response.json['routes'][0]['legs'][0]['duration']['value'];
  }
}
