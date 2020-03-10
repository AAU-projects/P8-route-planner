import 'package:flutter/material.dart';
import 'package:route_app/core/utils/environment.dart' as environment;
import 'package:route_app/routes.dart';
import 'locator.dart';

/// Is the app in debug mode
const bool Debug = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  if (Debug) {
    environment.setFile('assets/environments.json').whenComplete(() {
      runApp(App());
    });
  } else {
    environment.setFile('assets/environments.prod.json').whenComplete(() {
      runApp(App());
    });
  }
}

/// Main app class
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App name',
      initialRoute: '/',
      routes: routes,
    );
  }
}
