import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

///
class LocationModel extends ChangeNotifier {
  ///
  LocationModel() {
    updateCurrentLocation();
  }

  ///
  String _currentLocation = 'Loading';

  ///
  String get currentLocation => _currentLocation;

  ///
  void updateCurrentLocation() {
    updateLocation(getCurrentLocation());
  }

  ///
  Future<Position> getCurrentLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  ///
  void updateLocation(Future<Position> loc) {
    loc.then((Position value) {
      _currentLocation = value.toString();
      notifyListeners();      
    });
  }
}
