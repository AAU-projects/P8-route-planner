import 'dart:convert';

import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';

/// User Endpoints
class UserService implements UserAPI{
  /// Default constructor
  UserService({
    String endpoint = 'user/',
    String databaseTable = 'user'
  }): _endpoint = endpoint, _dbTable = databaseTable;

  final String _endpoint;
  final String _dbTable;

  final Http _http = locator.get<Http>();
  final DatabaseService _db = locator.get<DatabaseService>();

  User _user;

  @override
  Future<User> get activeUser async {
   if (_user != null) {
     return _user;
   }
   final List<Map<String, dynamic>> result =
       await _db.query(_dbTable, limit:1);

   if (result.isNotEmpty) {
     if (result.first.containsKey('json')) {
       return User.fromJson(jsonDecode(result.first['json']));
     }
   }

   return null;
  }

  @override
  void setActiveUser(User user) {
    _user = user;

    _db.delete(_dbTable, where: '1').then((_) {
      _db.insert(_dbTable, <String, String>{
        'json': jsonEncode(user.toJson())
      });
    });
  }

  @override
  Future<List<User>> getAllUsers() {
    // TODO: implement getAllUsers
    return null;
  }

  @override
  Future<User> getUser(String id) {
    // TODO: implement getUser
    return null;
  }

  @override
  Future<User> updateUser(String id, User newUser) {
    // TODO: implement updateUser
    return null;
  }
}