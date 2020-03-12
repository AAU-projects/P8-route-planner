import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

///
class LocationModel extends ChangeNotifier {
  /// Class Constructor
  LocationModel() {
      initialize();
  }

  void initialize() async {
      await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    //updateCurrentLocation();
    updateLastKnownLocation();
  }

  final Geolocator _geolocator = Geolocator();
  String _currentLocation = 'Loading';
  String _lastKnownLocation = 'N/A';

  /// Get current location
  String get currentLocation => _currentLocation;

  /// Get last known location
  String get lastKnownLocation => _lastKnownLocation;

  ///
  void updateCurrentLocation() {
    _updateCurrentLocation(_getCurrentLocation());
  }

  ///
  void updateLastKnownLocation() {
    _updateLastKnownLocation(_getLastKnownLocation());
  }

  Future<Position> _getCurrentLocation() async {
    return _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<Position> _getLastKnownLocation() async {
    return _geolocator
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
  }

  void _updateCurrentLocation(Future<Position> loc) {
    loc.then((Position value) {
      _currentLocation = value.toString();
      notifyListeners();
    });
  }

  void _updateLastKnownLocation(Future<Position> loc) {
    loc.then((Position value) {
      _lastKnownLocation = value.toString();
      notifyListeners();
    });
  }
}
