import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/API/http_service.dart';
import 'package:route_app/core/services/API/user_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/locator.dart';

/// Authentication endpoints
class AuthenticationService {
  /// Default constructor
  AuthenticationService({
    String endpoint = 'user/',
    String databaseTable = 'auth'
  }): _endpoint = endpoint, _dbTable = databaseTable;

  final String _endpoint;
  final String _dbTable;

  final DatabaseService _db = locator.get<DatabaseService>();
  final HttpService _http = locator.get<HttpService>();
  final UserService _userService = locator.get<UserService>();

  ///
  Future<User> login(String email, String pin) async {

    //_userService.setActiveUser(user);
  }

  ///
  Future<bool> sendPin(String email) async {

  }

  ///
  Future<User> register(String email) async {

  }

  ///
  Future<User> refreshToken() async {

    //_userService.setActiveUser(user);
  }

  ///
  Future<User> loginWithToken(String token) async {

    //_userService.setActiveUser(user);
  }


}