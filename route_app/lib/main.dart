import 'package:flutter/material.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/utils/environment.dart' as environment;
import 'package:route_app/routes.dart';
import 'core/services/interfaces/API/user.dart';
import 'locator.dart';

/// Is the app in debug mode
const bool Debug = true;

String _initScreen = '/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();


  if (Debug) {
    environment.setFile('assets/environments.json').whenComplete(() {
      final UserAPI _user = locator.get<UserAPI>();
      _user.activeUser.then((User user) {
        if (user != null) {
          _initScreen = '/test';
        }
        runApp(App());
      });
    });
  } else {
    environment.setFile('assets/environments.prod.json').whenComplete(() {
      final UserAPI _user = locator.get<UserAPI>();
      _user.activeUser.then((User user) {
        if (user != null) {
          _initScreen = '/test';
        }
        runApp(App());
      });
    });
  }
}

/// Main app class
class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App name',
      routes: routes,
      initialRoute: _initScreen,
    );
  }
}
