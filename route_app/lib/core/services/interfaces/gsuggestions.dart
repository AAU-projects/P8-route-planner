import 'package:geolocator/geolocator.dart';
import 'package:route_app/core/models/suggestion_result_model.dart';

/// Google Maps Place Autocomplete interface:
abstract class GoogleAutocompleteAPI {
  /// Get search suggestions from Google API
  Future<List<SuggestionResult>> getSuggestions(
      String input, Position currentPos);
}
