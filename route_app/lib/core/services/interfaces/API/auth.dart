import 'package:route_app/core/models/user_model.dart';

/// Authentication API interface
abstract class AuthAPI {

  /// Login API Flow
  Future<User> login(String pin, {String email});

  /// Request a pincode from the API sent to email
  Future<bool> sendPin(String email);

  /// Register API flow
  Future<User> register(String email, {String kml, String fuelType});

  /// Get a new JWT token from the API
  Future<User> refreshToken();

  /// Login using the JWT Token
  Future<User> loginWithToken(String token);
}