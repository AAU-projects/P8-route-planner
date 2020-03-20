/// Int extension
extension IntegerExtension on int {
  /// Is this between values
  bool between(int lower, int higher) {
    return lower < this && this < higher;
  }

  /// Is this bigger then value
  bool isAbove(int a) {
    return this > a;
  }

  /// Is this lover then value
  bool isBelow(int a) {
    return this < a;
  }

  /// Boolean representation
  bool toBool() {
    return this > 0;
  }
}