import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:route_app/layout/screens/home.dart';
import 'package:route_app/layout/screens/test.dart';
import 'layout/screens/confirm_login.dart';
import 'layout/screens/login.dart';
import 'layout/screens/register.dart';
import 'layout/screens/welcome.dart';

/// routes for the application
Map<String, Widget Function(BuildContext)> routes =
    <String, Widget Function(BuildContext)>{
  // When navigating to "/" route, build the WelcomeScreen widget
  '/': (_) => const WelcomeScreen(),
  // When navigating to "/login" route, build the LoginScreen widget
  '/login': (_) => LoginScreen(),
  // When navigating to 'login/confirm', build the ConfirmLoginScreen widget
  '/login/confirm': (_) => ConfirmLoginScreen(),
  // When navigating to "/register" route, build the RegisterScreen widget
  '/register': (_) => RegisterScreen(),
  // Test screen, will show what ever is being tested
  '/test': (_) => TestScreen(),
  /// Home screen with map
  '/home': (_) => HomeScreen(),
};
