import 'package:flutter/material.dart';
import 'package:route_app/layout/router.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/core/utils/environment.dart' as environment;

/// Is the app in debug mode
const bool Debug = true;

void main() {
  setupLocator();

  if(Debug) {
    environment.setFile('assets/environment.json').whenComplete(() {
      runApp(RouteApp());
    });
  } else {
    environment.setFile('assets/environment.prod.json').whenComplete(() {
      runApp(RouteApp());
    });
  }
}

/// Main app class
class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route App',
      theme: ThemeData(),
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
    );
  }

}