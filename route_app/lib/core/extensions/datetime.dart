/// DateTime Extension
extension DateTimeExtension on DateTime {
  /// Parse a DateTime object to a String, if null returns empty string
  String parseToString() {
    if (this == null) {
      return '';
    }
    return toIso8601String();
  }
}
