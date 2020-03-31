
import 'package:route_app/core/models/directions_model.dart';

/// Google Maps interface
abstract class GoogleMapsAPI {
  /// Gets direction from 'origin' to 'destination'
  Future<Directions> getDirections({String origin, String destination, 
    String travelMode = 'driving'});
}