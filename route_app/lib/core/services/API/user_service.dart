import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/API/http_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/locator.dart';

/// User Endpoints
class UserService {
  /// Default constructor
  UserService({
    String endpoint = 'user/',
  }): _endpoint = endpoint;

  final String _endpoint;

  final HttpService _http = locator.get<HttpService>();

  User _user;

  /// The currently loggedIn user
  User get activeUser => _user;

  ///
  void setActiveUser(User user) {
    _user = user;
  }
}