import 'package:flutter/material.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/core/utils/environment.dart' as environment;

import 'locator.dart';

/// Is the app in debug mode
const bool Debug = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  if(Debug) {
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
      title: 'Route planner',
      initialRoute: '/',
      routes: {
        // When navigating to "/" route, build the WelcomeScreen widget
        '/': (_) => WelcomeScreen(),
        // When navigating to "/login" route, build the LoginScreen widget
        '/login': (_) => LoginScreen(),
        // When navigating to "/register" route, build the RegisterScreen widget
        '/register': (_) => RegisterScreen(),
      },
    );
  }
}