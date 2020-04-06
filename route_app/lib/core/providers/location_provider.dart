import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

/// Location model which can be used in a 'ChangeNotifier' provider.
class LocationProvider extends ChangeNotifier {
  /// Class Constructor
  LocationProvider() {
    getPermission().then((bool value) => value ? _initialize() : null);
  }

  final Geolocator _geolocator = Geolocator();
  String _currentLocation = 'Loading';
  Position _currentLocationObj;
  String _lastKnownLocation = 'N/A';
  Position _lastKnownLocationObj;
  Position _addressPosition;
  String _positionAddress;
  double _distanceOut;

  /// Permission to get location
  Future<bool> get permission async => _geolocator
          .checkGeolocationPermissionStatus()
          .then((GeolocationStatus status) {
        return status == GeolocationStatus.granted;
      });

  /// Get current location
  String get currentLocation => _currentLocation;

  /// Get last known location
  String get lastKnownLocation => _lastKnownLocation;

  /// Get current location object
  Position get currentLocationObj => _currentLocationObj;

  /// Get last known location object
  Position get lastKnownLocationObj => _lastKnownLocationObj;

  /// Get the position from an address
  Position get addressPosition => _addressPosition;

  /// Get the address from a position
  String get positionAddress => _positionAddress;

  /// Get the distance output
  double get distanceOut => _distanceOut;

  /// Gets permission to use location data
  Future<bool> getPermission() {
    return _geolocator
        .checkGeolocationPermissionStatus()
        .then((GeolocationStatus status) async {
      if (status == GeolocationStatus.granted) {
        return true;
      } else {
        try {
          await _geolocator.getCurrentPosition();
          return true;
        } on PlatformException catch (_) {
          return false;
        }
      }
    });
  }

  /// Get Position the position stream
  Stream<Position> positionStream() {
    final LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    return _geolocator.getPositionStream(locationOptions);
  }

  /// Update the current location, notifies screens to update
  Future<bool> updateCurrentLocation() async {
    final Position cPos =
        await _startCurrentLocationUpdate().catchError((Object onError) async {
      return null;
    });
    _currentLocation = cPos.toString();
    _currentLocationObj = cPos;

    notifyListeners();
    return true;
  }

  /// Update the last known location, notifies screens to update
  Future<bool> updateLastKnownLocation() async {
    final Position lPos = await _startLastKnownLocationUpdate();
    _lastKnownLocation = lPos.toString();
    _lastKnownLocationObj = lPos;

    notifyListeners();
    return true;
  }

  /// Get a position from an address, notifies screens to update
  Future<bool> updatePositionFromAddress(String addr) async {
    _addressPosition = await _updatePositionFromAddress(addr);

    notifyListeners();
    return true;
  }

  /// Get an address from a position, notifies screens to update
  Future<bool> updateAddressFromPosition(Position pos) async {
    _positionAddress = await _updateAddressFromPosition(pos);

    notifyListeners();
    return true;
  }

  /// Get the distance between two positions
  Future<bool> updateDistanceBetweenPositions(
      Position pos1, Position pos2) async {
    await _geolocator.distanceBetween(
        pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
    return true;
  }

  Future<bool> _initialize() async {
    await updateCurrentLocation();
    await updateLastKnownLocation();
    return true;
  }

  Future<Position> _updatePositionFromAddress(String addr) {
    return _geolocator.placemarkFromAddress(addr).then((List<Placemark> list) {
      return list.first.position;
    });
  }

  Future<String> _updateAddressFromPosition(Position pos) {
    return _geolocator
        .placemarkFromCoordinates(pos.latitude, pos.longitude)
        .then((List<Placemark> list) {
      return list.first.thoroughfare;
    });
  }

  Future<Position> _startCurrentLocationUpdate() async {
    return _updateCurrentLocation(_getCurrentLocation())
        .catchError((Object onError) async {
      return null;
    });
  }

  Future<Position> _startLastKnownLocationUpdate() async {
    return _updateLastKnownLocation(_getLastKnownLocation());
  }

  Future<Position> _getCurrentLocation() async {
    return _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .catchError((Object onError) async {
      return null;
    });
  }

  Future<Position> _getLastKnownLocation() async {
    return _geolocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<Position> _updateCurrentLocation(Future<Position> loc) async {
    Position result;
    await loc.then((Position value) {
      result = value;
    });
    return result;
  }

  Future<Position> _updateLastKnownLocation(Future<Position> loc) async {
    Position result;
    await loc.then((Position value) {
      result = value;
    });
    return result;
  }
}
