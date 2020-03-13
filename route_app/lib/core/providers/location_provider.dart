import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

/// Location model which can be used in a 'ChangeNotifier' provider.
class LocationModel extends ChangeNotifier {
  /// Class Constructor
  LocationModel() {
    _initialize();
  }

  final Geolocator _geolocator = Geolocator();
  String _currentLocation = 'Loading';
  String _lastKnownLocation = 'N/A';

  Future<bool> _initialize() async {
    _currentLocation = await updateCurrentLocation();
    _lastKnownLocation = await updateLastKnownLocation();
    notifyListeners();
    return true;
  }

  /// Update the current location
  Future<String> updateCurrentLocation() async {
      return _updateCurrentLocation(_getCurrentLocation());
  }

  /// Update the last known location
  Future<String> updateLastKnownLocation() async {
      return _updateLastKnownLocation(_getLastKnownLocation());
  }

  /// Get current location
  String get currentLocation => _currentLocation;

  /// Get last known location
  String get lastKnownLocation => _lastKnownLocation;

  Future<Position> _getCurrentLocation() async {
    return _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<Position> _getLastKnownLocation() async {
    return _geolocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<String> _updateCurrentLocation(Future<Position> loc) async {
    String result;
    await loc.then((Position value) {
      result = value.toString();
    });
    return result;
  }

  Future<String> _updateLastKnownLocation(Future<Position> loc) async {
    String result;
    await loc.then((Position value) {
      result = value.toString();
    });
    return result;
  }
}
