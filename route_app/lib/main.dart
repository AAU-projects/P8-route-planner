import 'package:flutter/material.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/locator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/core/utils/environment.dart' as environment;

/// Is the app in debug mode
const bool Debug = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (BuildContext context) => WelcomeScreen(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/login': (BuildContext context) => LoginScreen(),
      '/register': (BuildContext context) => RegisterScreen(),
    },
  ));
}
/// Main app class
/* class RouteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
} */