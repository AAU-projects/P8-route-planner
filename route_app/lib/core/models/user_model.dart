import 'package:route_app/core/models/model.dart';
import 'package:route_app/core/extensions/map.dart';
import 'package:route_app/core/extensions/datetime.dart';

/// User model containing data about the user retrieved from the backend
class User implements Model {
  /// Default constructor
  User(this.id, this.email, this.carEmission, this.pincode, this.token,
      this.pinExpirationDate, this.tokenExpirationDate);

  /// Constructor to instantiate from json
  User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException('Cant initialize on empty json');
    }
    id = json['Id'];
    email = json['Email'];
    carEmission = json['CarEmission'];
    pincode = json['Pincode'];
    token = json['Token'];
    pinExpirationDate = _parseToDateTime(json.get('PinExpirationDate', null));
    tokenExpirationDate =
        _parseToDateTime(json.get('TokenExpirationDate', null));
  }

  DateTime _parseToDateTime(String value) {
    if (value == null) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  /// The user's id
  String id;

  /// The user's email
  String email;

  /// The user's car emission
  double carEmission;

  /// Pincode used to login or register
  String pincode;

  /// The user's JWT token
  String token;

  /// The expiration date of the pincode
  DateTime pinExpirationDate;

  /// The expiration date of the JWT token
  DateTime tokenExpirationDate;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'Id': id,
      'Email': email,
      'CarEmission': carEmission,
      'Pincode': pincode,
      'Token': token,
      'PinExpirationDate': pinExpirationDate.parseToString(),
      'TokenExpirationDate': tokenExpirationDate.parseToString()
    };
  }
}
