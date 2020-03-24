/// Map extension
extension MapExtension<T, X> on Map<T, X> {
  /// Get value from map by key, return default value if key dont exists or null
  X get(T key, [X defaultValue]) {
    if (this.containsKey(key)) { // ignore: unnecessary_this
      return this[key];
    } else {
      return defaultValue;
    }
  }
}