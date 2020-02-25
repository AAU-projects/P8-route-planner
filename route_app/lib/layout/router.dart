import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// App navigation class
class Router {
  /// Generate the app's navigation paths
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(builder: (_) => const Scaffold(
          body: Center(
            child: Text('Route App'),
          ),
        ));
      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          )
        );
    }
  }
}