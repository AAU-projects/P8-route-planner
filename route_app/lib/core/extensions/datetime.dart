/// DateTime Extension
extension DateTimeExtension on DateTime {
  ///
  String parseToString() {
    if (this == null) {
      return '';
    }
    return toIso8601String();
  }
}