import 'dart:convert';

import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';

/// Authentication endpoints
class AuthenticationService implements AuthAPI {
  /// Default constructor
  AuthenticationService({String endpoint = 'user/'}) : _endpoint = endpoint;

  final String _endpoint;
  final Http _http = locator.get<Http>();
  final UserAPI _userService = locator.get<UserAPI>();

  String _currentEmail;

  @override
  Future<User> login(String pin, {String email}) async {
    if (email == null && _currentEmail == null) {
      throw 'No email provided! Either set email with sendPin or provide it '
          'as named parameter';
    }
    email ??= _currentEmail;
    return _http.post(_endpoint + 'login',
        <String, String>{'Email': email, 'Pincode': pin}).then((Response res) {
      final User usr = User.fromJson(res.json);
      _userService.setActiveUser(usr);
      _http.setToken(usr.token, usr.tokenExpirationDate.toIso8601String());
      return usr;
    });
  }

  @override
  Future<bool> sendPin(String email) async {
    _currentEmail = email;
    return _http
        .post(_endpoint + 'pincode', <String, String>{'Email': email}).then(
            (Response res) {
      return res.json['result'];
    });
  }

  @override
  Future<User> register(String email, {String licensePlate}) async {
    return _http.post(_endpoint + 'register', <String, String>{
      'Email': email,
      'LicensePlate': licensePlate ??= ''
    }).then((Response res) {
      return User.fromJson(res.json);
    });
  }

  @override
  Future<User> refreshToken() async {
    throw 'Not implemented';
    //_userService.setActiveUser(user);
  }

  @override
  Future<User> loginWithToken(String token) async {
    throw 'Not implemented';
    //_userService.setActiveUser(user);
  }
}
