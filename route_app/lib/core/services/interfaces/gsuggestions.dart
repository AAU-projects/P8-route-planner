
/// Google Maps Place Autocomplete interface:
abstract class GoogleAutocompleteAPI {
  /// Get search suggestions from Google API
  Future<List<String>> getSuggestions(String input);

}