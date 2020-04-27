/// Model to store location with distance from API call
class SuggestionResult {
  /// Default contructor
  SuggestionResult(this.distance, this.location);

  /// The distance in meter from origin
  int distance;

  /// The location name as a string
  String location;
}
