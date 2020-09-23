RegExp _emailMatcher = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp _pinMatcher = RegExp(r'^\d{4}$');

/// Email validator
bool email(String email) {
  if (email == null) {
    return false;
  }
  return _emailMatcher.hasMatch(email);
}

/// PIN code validator
bool pin(String pin) {
  if (pin == null) {
    return false;
  }
  final String _pin = pin.replaceAll(' ','');
  return _pinMatcher.hasMatch(_pin);
}

/// Kml double validator
bool kml(String kml) {
  try {
    double.parse(kml);
    return true;
  } catch (e) {
    return false;
  }
}