import 'package:route_app/core/models/user_model.dart';

/// User API endpoints
abstract class UserAPI {

  /// The currently loggedIn user
  Future<User> get activeUser;

  /// Set the active user in the app
  void setActiveUser(User user);

  /// Logs a user out from the system
  void logout();

  /// Get all users from API
  Future<List<User>> getAllUsers();

  /// Get user from API with id
  Future<User> getUser(String id);

  /// Update a user with new values by id
  Future<User> updateUser(String id, User newUser);

}