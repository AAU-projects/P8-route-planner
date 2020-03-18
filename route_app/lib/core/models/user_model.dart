import 'package:route_app/core/models/model.dart';

/// User model containing data about the user retrieved from the backend
class User implements Model{
  /// Default constructor
  User(this.id, this.email, this.licensePlate, this.pincode, this.token,
       this.pinExpirationDate, this.tokenExpirationDate);

  /// Constructor to instantiate from json
  User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException('Cant initialize on empty json');
    }
    id = json['Id'];
    email = json['Email'];
    licensePlate = json['LicensePlate'];
    pincode = json['Pincode'];
    token = json['Token'];
    pinExpirationDate = DateTime.parse(json['PinExpirationDate']);
    tokenExpirationDate = DateTime.parse(json['TokenExpirationDate']);
  }

  /// The user's id
  String id;
  /// The user's email
  String email;
  /// The user's license plate
  String licensePlate;
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
      'LicensePlate': licensePlate,
      'Pincode': pincode,
      'Token': token,
      'PinExpirationDate': pinExpirationDate,
      'TokenExpirationDate': tokenExpirationDate
    };
  }
}