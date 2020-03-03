import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../constants/colors.dart' as color;

/// Documentation
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.Background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Text('Welcome to "App Name"',
                    style: TextStyle(fontSize: 25.0, color: color.Text))),
            Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {},
                  child: const Text('Login'),
                  color: color.ButtonBackground,
                  textColor: color.Text,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: const Text('Register'),
                  color: color.ButtonBackground,
                  textColor: color.Text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
