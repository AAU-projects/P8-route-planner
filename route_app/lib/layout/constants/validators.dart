RegExp _emailMatcher = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
RegExp _licensePlateMatcher = RegExp(r'([A-Za-zæøåÆØÅ0-9])+');

/// Email validator
bool email(String email) {
  if (email == null) {
    return false;
  }
  return _emailMatcher.hasMatch(email);
}
  
/// Danish license plate validator
bool licensePlate(String plate) {
  if (plate == null) {
    return false;
  }
  final String _plate = plate.replaceAll(' ','');
  return _plate.length > 2
    ? _plate.length < 7
      ? _licensePlateMatcher.hasMatch(_plate) 
      :false 
    : false;
}
